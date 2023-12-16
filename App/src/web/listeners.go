package web

import (
	"fmt"
	"log"
	"mime/multipart"
	"net/http"

	"github.com/CatInsideBoxUnderTheTable/ITransferWeb/storage"

	"github.com/labstack/echo/v4"
)

func MainPageListener(c echo.Context) error {
	return c.String(http.StatusOK, "hell yeah")
}

// retrieves field: file from form and uploads it to bucket. Returns URI link with time constraint
func UploadFileListener(c echo.Context, bucketName string, uploader storage.BucketMultipartFileUploader) error {
	log.Println("Upload request received")
	f, err := retrieveUpload(c)
	if err != nil {
		return err
	}

	uploader.InitializeSession(bucketName)
	err = uploader.PostMultipartObject(f.FileContent, f.FileName)
	if err != nil {
		return err
	}

	const objectLifetime = 2
	uri, err := uploader.GetObjectUrl(f.FileName, objectLifetime)
	if err != nil {
		return err
	}
	c.String(http.StatusOK, uri)

	return nil
}

type multipartFile struct {
	FileName    string
	FileContent multipart.File
}

func retrieveUpload(c echo.Context) (multipartFile, error) {
	const maxFileSize = 50_000_000 //50 MB
	file, err := c.FormFile("file")
	if err != nil {
		return multipartFile{}, err
	}

	if file.Size >= maxFileSize {
		return multipartFile{}, fmt.Errorf("file size exceeded. Max allowed size is: %v", maxFileSize)
	}

	src, err := file.Open()
	if err != nil {
		return multipartFile{}, err
	}

	return multipartFile{
		FileName:    file.Filename,
		FileContent: src,
	}, nil
}
