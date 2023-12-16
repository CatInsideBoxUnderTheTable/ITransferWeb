package input

import (
	"fmt"
	"os"
)

type awsEnvConfig struct {
	BucketName   string
	BucketRegion string
	AuthLogin    string
	AuthKey      string
}

type authEnvConfig struct {
	Login    string
	Password string
}

type Appsettings struct {
	AwsConfig  awsEnvConfig
	AuthConfig authEnvConfig
	Port       string
}

func GetAppsettings() (Appsettings, error) {

	port, err := readEnvironmentVariableAsString("APP_PORT")
	if err != nil {
		return Appsettings{}, err
	}

	auth, err := getAuthConfig()
	if err != nil {
		return Appsettings{}, err
	}

	aws, err := getAwsConfig()
	if err != nil {
		return Appsettings{}, err
	}
	return Appsettings{
		AwsConfig:  aws,
		AuthConfig: auth,
		Port:       port,
	}, nil

}

func getAuthConfig() (authEnvConfig, error) {
	login, err := readEnvironmentVariableAsString("APP_LOGIN")
	if err != nil {
		return authEnvConfig{}, err
	}

	password, err := readEnvironmentVariableAsString("APP_PASSWORD")
	if err != nil {
		return authEnvConfig{}, err
	}

	return authEnvConfig{
		Password: password,
		Login:    login,
	}, nil
}

func getAwsConfig() (awsEnvConfig, error) {
	bucketName, err := readEnvironmentVariableAsString("AWS_STORAGE_BUCKET_NAME")
	if err != nil {
		return awsEnvConfig{}, err
	}

	bucketRegion, err := readEnvironmentVariableAsString("AWS_STORAGE_BUCKET_REGION")
	if err != nil {
		return awsEnvConfig{}, err
	}

	login, err := readEnvironmentVariableAsString("AWS_CONSOLE_LOGIN")
	if err != nil {
		return awsEnvConfig{}, err
	}

	key, err := readEnvironmentVariableAsString("AWS_CONSOLE_KEY")
	if err != nil {
		return awsEnvConfig{}, err
	}

	return awsEnvConfig{
		BucketName:   bucketName,
		BucketRegion: bucketRegion,
		AuthLogin:    login,
		AuthKey:      key,
	}, nil
}

func readEnvironmentVariableAsString(envVarName string) (string, error) {
	val, exists := os.LookupEnv(envVarName)

	if !exists || stringEmpty(val) {
		return "", fmt.Errorf("required environment variable %s is invalid", envVarName)
	}

	return val, nil
}

func stringEmpty(val string) bool {
	if len(val) == 0 {
		return true
	}

	for _, char := range val {
		if char != ' ' {
			return false
		}
	}

	return true
}
