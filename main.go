package main

import (
	"fmt"
	"log"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/cmd"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/wire"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/database"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"go.uber.org/zap"
)

func main() {
	// init config
	config, err := utils.ReadConfiguration()
	if err != nil {
		log.Fatal("cant read config")
	}
	// init logger
	logger, err := utils.InitLogger(config.PathLogging, config.Debug)
	if err != nil {
		log.Fatal("cant initialize logger")
	}
	// init db
	dbPool, err := database.Connect(logger, config.DB)
	if err != nil {
		logger.Error("cant initialize database", zap.Error(err))
		log.Fatal(err)
	}

	// init layer
	repo := repository.NewRepository(dbPool, logger)
	app := wire.Wiring(repo, logger, config)

	// start app
	fmt.Println(config.AppName, "is starting...")
	cmd.APIServer(app, config, logger)

}
