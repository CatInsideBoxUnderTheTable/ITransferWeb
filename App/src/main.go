package main

import (
	"log"

	"github.com/CatInsideBoxUnderTheTable/ITransferWeb/input"
	s3storage "github.com/CatInsideBoxUnderTheTable/ITransferWeb/storage/s3"
	"github.com/CatInsideBoxUnderTheTable/ITransferWeb/web"
	"github.com/labstack/echo/v4"
)

func main() {
	appsettings, err := input.GetAppsettings()
	if err != nil {
		log.Fatalf("Config error:, %s", err)
	}

	authConfig := web.AuthConfig{
		Login:    appsettings.AuthConfig.Login,
		Password: appsettings.AuthConfig.Password,
	}

	uploadFileListenerClosure := func(c echo.Context) error {
		adapter := s3storage.S3Adapter{
			ConnectionManager: s3storage.FileAuthManager{
				Region:   appsettings.AwsConfig.BucketRegion,
				Login:    appsettings.AwsConfig.AuthLogin,
				Password: appsettings.AwsConfig.AuthKey,
			},
		}
		return web.UploadFileListener(c, appsettings.AwsConfig.BucketName, &adapter)
	}

	controllersDefinitions := []web.Controller{
		{
			Path:               "/",
			ControllerListener: web.MainPageListener,
		},
		{
			Path:               "/upload",
			ControllerListener: uploadFileListenerClosure,
		},
	}

	web.SetupHttpServer(controllersDefinitions, appsettings.Port, authConfig)
}
