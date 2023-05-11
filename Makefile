VERSION=$(shell git describe --tags --abbrev=0)
OS=linux
ARCH=amd64

format:
	gofmt -s -w ./

build:
	CGO_ENABLED=0 GOOS=${OS} GOARCH=${ARCH} go build -v -o kbot -ldflags "-X="github.com/svolkov/kbot/cmd.appVersion=${VERSION}