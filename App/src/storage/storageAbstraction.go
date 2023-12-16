package storage

import "mime/multipart"

type BucketSystemFileUploader interface {
	InitializeSession(bucketName string)
	PostSystemObject(filePath string, objectName string) error
	GetObjectUrl(objectName string, urlExpirationHours uint) (string, error)
	Close()
}

type BucketMultipartFileUploader interface {
	InitializeSession(bucketName string)
	PostMultipartObject(file multipart.File, objectName string) error
	GetObjectUrl(objectName string, urlExpirationHours uint) (string, error)
	Close()
}

type AuthManager interface {
	OpenSession()
	GetExistingSession() any
	Close()
}
