package cmd

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/wire"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"go.uber.org/zap"
)

func APIServer(app *wire.App, config *utils.Configuration, logger *zap.Logger) {
	fmt.Println(config.AppName, "is running on port 8080")

	go func() {
		if err := http.ListenAndServe(":"+config.Port, app.Route); err != nil {
			logger.Error("can't run server", zap.Error(err))
			log.Fatal("can't run service")
		}
	}()

	// gracefully shutdown ------------------------------------------------------------------------
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	close(app.Stop)
	app.WG.Wait()

	log.Println("exiting", config.AppName)
}
