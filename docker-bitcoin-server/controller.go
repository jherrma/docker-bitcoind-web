package main

import (
	"fmt"
	"log"
	"os/exec"
	"path"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/jon-ryan/go-bitcoind"
)

type ApiController struct {
	btcd   *bitcoind.Bitcoind
	config *BitcoinConfig
}

const debugFileName = "debug.log"

func NewApiController(config *BitcoinConfig) (*ApiController, error) {
	btcd, err := bitcoind.New(config.ServerHost, int(config.ServerPort), config.User, config.Password, false, 10)
	if err != nil {
		return nil, err
	}

	return &ApiController{
		btcd:   btcd,
		config: config,
	}, nil
}

func (a *ApiController) Start() error {
	confArg := fmt.Sprintf("-conf=%s", a.config.ConfPath)
	cmd := exec.Command("bitcoind", confArg)
	_, err := cmd.Output()
	return err
}

func (a *ApiController) Stop() error {
	a.btcd.Stop()

	debugLogFilePath := path.Join(a.config.RootDirectory, debugFileName)

	for {
		time.Sleep(time.Second * 1)

		cmd := exec.Command("tail", debugLogFilePath)
		outputBytes, err := cmd.CombinedOutput()
		if err != nil {
			log.Println(err)
			return err
		}

		output := string(outputBytes)
		log.Println(output)
		if strings.Contains(output, "Shutdown: done") {
			return nil
		}
	}
}

func (a *ApiController) GetCollectedInfo(c *fiber.Ctx) error {

	blockChainInfo, err := a.btcd.GetBlockchainInfo()
	if err != nil {
		return fmt.Errorf("could not get blockChainInfo due to %s", err.Error())
	}

	sizeMega := 1000 * 1000
	sizeOnDiskInMb := int(blockChainInfo.SizeOnDisk / uint64(sizeMega))
	blocks := blockChainInfo.Blocks

	networkInfo, err := a.btcd.GetNetworkInfo()
	if err != nil {
		return fmt.Errorf("could not get networkInfo due to %s", err.Error())
	}

	memPoolInfo, err := a.btcd.GetMemPoolInfo()
	if err != nil {
		return fmt.Errorf("could not get mempoolInfo due to %s", err.Error())
	}

	latestBlockInfo, err := a.getLatestBlockInfo(blocks)
	if err != nil {
		return err
	}

	secondsSinceLatestBlock := getSecondsSinceLatestBlock(latestBlockInfo)

	versionMajor := networkInfo.Version / 10000
	versionMinor := (networkInfo.Version / 100) % 100
	versionPatch := networkInfo.Version % 100

	version := fmt.Sprintf("v%d.%d.%d", versionMajor, versionMinor, versionPatch)

	verificationProgress := blockChainInfo.VerificationProgress
	if verificationProgress < 0.001 {
		verificationProgress = 0
	}

	uptime, err := a.btcd.GetUptime()
	if err != nil {
		return err
	}

	return c.JSON(fiber.Map{
		"sizeOnDiskInMb":          sizeOnDiskInMb,
		"blocks":                  blockChainInfo.Blocks,
		"secondsSinceLatestBlock": secondsSinceLatestBlock,
		"txInLatestBlock":         getTxInLatestBlock(latestBlockInfo),
		"verificationProgress":    verificationProgress,
		"connectionsIncoming":     networkInfo.ConnectionsIn,
		"connectionsOutgoing":     networkInfo.ConnectionsOut,
		"txInMemPool":             memPoolInfo.Size,
		"uptime":                  uptime,
		"version":                 version,
		"chain":                   blockChainInfo.Chain,
	})
}

func (a *ApiController) getLatestBlockInfo(blocks uint64) (*bitcoind.Block, error) {
	if blocks == 0 {
		return nil, nil
	}

	latestBlockHash, err := a.btcd.GetBlockHash(blocks)
	if err != nil {
		return nil, fmt.Errorf("could not get latestBlockHash due to %s", err.Error())
	}

	latestBlockInfo, err := a.btcd.GetBlock(latestBlockHash)
	if err != nil {
		return nil, fmt.Errorf("could not get latestBlockInfo due to %s", err.Error())
	}

	return &latestBlockInfo, nil
}

func getTxInLatestBlock(latestBlockInfo *bitcoind.Block) int {
	if latestBlockInfo == nil {
		return -1
	}

	return len(latestBlockInfo.Tx)
}

func getSecondsSinceLatestBlock(latestBlockInfo *bitcoind.Block) int64 {
	if latestBlockInfo == nil {
		return -1
	}

	currentTime := time.Now().Unix()
	secondsSinceLatestBlock := currentTime - latestBlockInfo.Time
	return secondsSinceLatestBlock
}

func (a *ApiController) GetMemPoolInfo(c *fiber.Ctx) error {
	memPoolInfo, err := a.btcd.GetMemPoolInfo()
	if err != nil {
		return err
	}

	return c.JSON(fiber.Map{
		"loaded":           memPoolInfo.Loaded,
		"size":             memPoolInfo.Size,
		"bytes":            memPoolInfo.Bytes,
		"usage":            memPoolInfo.Usage,
		"totalfee":         memPoolInfo.TotalFee,
		"maxmempool":       memPoolInfo.MaxMemPool,
		"mempoolminfee":    memPoolInfo.MemPoolMinFee,
		"minrelaytxfee":    memPoolInfo.MinRelayTxFee,
		"unbroadcastcount": memPoolInfo.UnbroadcastCount,
	})
}

func (a *ApiController) GetBlockchainInfo(c *fiber.Ctx) error {
	blockChainInfo, err := a.btcd.GetBlockchainInfo()
	if err != nil {
		return err
	}

	return c.JSON(fiber.Map{
		"chain":                blockChainInfo.Chain,
		"blocks":               blockChainInfo.Blocks,
		"headers":              blockChainInfo.Headers,
		"bestblockhash":        blockChainInfo.BestBlockHash,
		"difficulty":           blockChainInfo.Difficulty,
		"time":                 blockChainInfo.Time,
		"mediantime":           blockChainInfo.Mediantime,
		"verificationprogress": blockChainInfo.VerificationProgress,
		"initialblockdownload": blockChainInfo.InitialBlockDownload,
		"chainwork":            blockChainInfo.Chainwork,
		"sizeondisk":           blockChainInfo.SizeOnDisk,
		"pruned":               blockChainInfo.Pruned,
		"pruneheight":          blockChainInfo.PruneHeight,
		"automatic_pruning":    blockChainInfo.AutomaticPruning,
		"prunetargetsize":      blockChainInfo.PruneTargetSize,
		"softforks":            blockChainInfo.Softforks,
		"warnings":             blockChainInfo.Warnings,
	})
}

func (a *ApiController) GetNetworkInfo(c *fiber.Ctx) error {
	networkInfo, err := a.btcd.GetNetworkInfo()
	if err != nil {
		return err
	}

	return c.JSON(fiber.Map{
		"version":            networkInfo.Version,
		"subversion":         networkInfo.Subversion,
		"protocolversion":    networkInfo.ProtocolVersion,
		"localservices":      networkInfo.LocalServices,
		"localservicesnames": networkInfo.LocalServicesNames,
		"localrelay":         networkInfo.LocalRelay,
		"timeoffset":         networkInfo.Timeoffset,
		"connections":        networkInfo.Connections,
		"connections_in":     networkInfo.ConnectionsIn,
		"connections_out":    networkInfo.ConnectionsOut,
		"networkactive":      networkInfo.NetworkActive,
		"networks":           networkInfo.Networks,
		"relayfee":           networkInfo.RelayFee,
		"incrementalfee":     networkInfo.IncrementalFee,
		"localaddresses":     networkInfo.LocalAddresses,
		"warnings":           networkInfo.Warnings,
	})
}

func (a *ApiController) GetMiningInfo(c *fiber.Ctx) error {
	miningInfo, err := a.btcd.GetMiningInfo()
	if err != nil {
		return err
	}

	return c.JSON(fiber.Map{
		"blocks":        miningInfo.Blocks,
		"difficulty":    miningInfo.Difficulty,
		"networkhashps": miningInfo.NetworkHashPerSecond,
		"pooledtx":      miningInfo.PooledtTx,
		"chain":         miningInfo.Chain,
		"warnings":      miningInfo.Warnings,
	})
}

func (a *ApiController) GetWalletInfo(c *fiber.Ctx) error {
	walletInfo, err := a.btcd.GetWalletInfo()
	if err != nil {
		return err
	}

	return c.JSON(fiber.Map{
		"walletname":            walletInfo.WalletName,
		"walletversion":         walletInfo.WalletVersion,
		"format":                walletInfo.Format,
		"txcount":               walletInfo.TxCount,
		"keypoololdest":         walletInfo.KeyPoolOldest,
		"keypoolsize":           walletInfo.KeyPoolSize,
		"keypoolsizehdinternal": walletInfo.KeyPoolSizeHdInternal,
		"unlockeduntil":         walletInfo.UnlockedUntil,
		"paytxfee":              walletInfo.PayTxFee,
		"hdseedid":              walletInfo.HdSeedId,
		"privatekeysenabled":    walletInfo.PrivateKeysEnabled,
		"avoidreuse":            walletInfo.AvoidReuse,
		"scanning":              walletInfo.Scanning,
		"descriptors":           walletInfo.Descriptors,
	})
}
