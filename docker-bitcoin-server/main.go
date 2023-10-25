package main

import (
	"log"
	"os"
	"os/signal"
	"syscall"

	"github.com/gofiber/fiber/v2"
)

func main() {

	config, err := InitBitcoinConfig()
	if err != nil {
		log.Fatalln(err)
	}

	err = StartBitcoinDaemon(config)
	if err != nil {
		log.Println("Something went wrong starting the bitcoin daemon")
		log.Fatalln(err)
	}

	apiController, err := NewApiController(config)
	if err != nil {
		log.Fatalln(err)
	}

	app := fiber.New()

	app.Static("/", "./frontend")

	app.Get("/api/mempoolinfo", apiController.GetMemPoolInfo)
	app.Get("/api/networkinfo", apiController.GetNetworkInfo)
	app.Get("/api/blockchaininfo", apiController.GetBlockchainInfo)
	app.Get("/api/walletinfo", apiController.GetWalletInfo)
	app.Get("/api/mininginfo", apiController.GetMiningInfo)
	app.Get("/api/collectedinfo", apiController.GetCollectedInfo)

	handleSystemSignals(app, apiController)
	app.Listen(":8080")
}

func handleSystemSignals(app *fiber.App, apiController *ApiController) {
	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)
	go func() {
		for range sigs {
			apiController.Stop()
			app.Shutdown()
		}
	}()
}
