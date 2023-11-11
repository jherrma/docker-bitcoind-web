package main

import (
	"bufio"
	"errors"
	"fmt"
	"log"
	"math/rand"
	"os"
	"os/exec"
	"path"
	"strconv"
	"strings"
)

type BitcoinConfig struct {
	RootDirectory string
	ConfPath      string
	ServerHost    string
	ServerPort    int64
	RpcAllowIp    string
	DisableWallet bool
	Daemon        bool
	User          string
	Password      string
}

const (
	letterBytes      = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	bitcoinDirectory = ".bitcoin"
	configFile       = "bitcoin.conf"
)

func InitBitcoinConfig() (*BitcoinConfig, error) {
	homedir, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("could not get user home directory")
	}

	pathToConfig := path.Join(homedir, bitcoinDirectory, configFile)
	log.Println(pathToConfig)

	config := &BitcoinConfig{
		RootDirectory: path.Join(homedir, bitcoinDirectory),
		ConfPath:      pathToConfig,
		ServerHost:    "127.0.0.1",
		ServerPort:    8332,
		RpcAllowIp:    "0.0.0.0/0",
		DisableWallet: true,
		Daemon:        true,
		User:          "bitcoinrpc",
		Password:      generatePassword(),
	}

	getEnvVars(config)

	configExists, err := configExists()
	if err != nil {
		return nil, err
	}

	if !configExists {
		err = writeConfig(config)
		if err != nil {
			return nil, err
		}
	} else {
		config, err = readConfig(pathToConfig)
		if err != nil {
			return nil, err
		}
	}

	return config, nil
}

func StartBitcoinDaemon(config *BitcoinConfig) error {
	confArg := fmt.Sprintf("-conf=%s", config.ConfPath)
	cmd := exec.Command("bitcoind", confArg)
	_, err := cmd.Output()
	return err
}

func generatePassword() string {
	b := make([]byte, 64)
	for i := range b {
		b[i] = letterBytes[rand.Int63()%int64(len(letterBytes))]
	}
	return string(b)
}

func getEnvVars(config *BitcoinConfig) {
	serverHostEnv := os.Getenv("RPCALLOWIP")
	if serverHostEnv != "" {
		config.ServerHost = serverHostEnv
	}

	serverPortEnv := os.Getenv("RPCBIND")
	if serverPortEnv != "" {
		serverPortEnvInt, err := strconv.ParseInt(serverPortEnv, 10, 0)
		if err != nil {
			config.ServerPort = serverPortEnvInt
		}
	}

	userEnv := os.Getenv("RPCUSER")
	if userEnv != "" {
		config.User = userEnv
	}

	pwEnv := os.Getenv("RPCPASSWORD")
	if pwEnv != "" {
		config.Password = pwEnv
	}
}

func configExists() (bool, error) {
	if _, err := os.Stat("/path/to/whatever"); err == nil {
		return true, nil
	} else if errors.Is(err, os.ErrNotExist) {
		return false, nil
	} else {
		return false, err
	}
}

func readConfig(pathToConfig string) (*BitcoinConfig, error) {
	file, err := os.OpenFile(pathToConfig, os.O_RDONLY, 0666)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	fileScanner := bufio.NewScanner(file)

	fileScanner.Split(bufio.ScanLines)

	config := &BitcoinConfig{}

	for fileScanner.Scan() {
		line := fileScanner.Text()
		segments := strings.Split(line, "=")
		if len(segments) < 2 {
			continue
		}

		key := segments[0]
		value := segments[1]

		switch key {
		case "rpcallowip":
			config.RpcAllowIp = value
		case "rpcbind":
			if strings.HasPrefix(value, ":") {
				config.ServerHost = "127.0.0.1"
				port, err := strconv.ParseInt(value[1:], 10, 64)
				if err != nil {
					return nil, err
				}
				config.ServerPort = port
				continue
			}

			if strings.Contains(value, ":") {
				ipSegments := strings.Split(value, ":")
				if len(ipSegments) < 2 {
					return nil, fmt.Errorf("could not parse rpcbind since the value contains a ':' but has less than 2 segments")
				}
				config.ServerHost = ipSegments[0]
				port, err := strconv.ParseInt(value[1:], 10, 64)
				if err != nil {
					return nil, err
				}
				config.ServerPort = port
				continue
			}

			config.ServerHost = value

		case "rpcuser":
			config.User = value
		case "rpcspassword":
			config.Password = value
		case "daemon":
			if value == "0" {
				config.Daemon = false
			} else {
				config.Daemon = true
			}

		case "disablewallet":
			if value == "0" {
				config.DisableWallet = false
			} else {
				config.DisableWallet = true
			}
		}

	}

	return config, nil
}

func writeConfig(config *BitcoinConfig) error {
	file, err := os.OpenFile(config.ConfPath, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, 0666)
	if err != nil {
		return err
	}
	defer file.Close()

	w := bufio.NewWriter(file)

	lines := []string{
		fmt.Sprintf("rpcallowip=%s", config.RpcAllowIp),
		fmt.Sprintf("rpcbind=%s:%d", config.ServerHost, config.ServerPort),
		fmt.Sprintf("rpcuser=%s", config.User),
		fmt.Sprintf("rpcpassword=%s", config.Password),
	}

	if config.Daemon {
		lines = append(lines, "daemon=1", "daemonwait=1")
	} else {
		lines = append(lines, "daemon=0")
	}

	if config.DisableWallet {
		lines = append(lines, "disablewallet=1")
	} else {
		lines = append(lines, "disablewallet=0")
	}

	for _, line := range lines {
		w.WriteString(line + "\n")
	}

	w.Flush()

	return nil
}
