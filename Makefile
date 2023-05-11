REGISTRY=ghcr.io/svolkov
APP=$(shell basename $(shell git remote get-url origin))
VERSION=$(shell git describe --tags --abbrev=0)
OS=linux
ARCH=amd64
#TAG=${REGISTRY}/${APP}:${VERSION}-${OS}


select_arm:
	$(eval ARCH=arm)

select_arm64:
	$(eval ARCH=arm64)

select_windows:
	$(eval OS=windows)

select_macos:
	$(eval OS=darwin)

macos: select_macos build

macos_arm64: select_macos select_arm64 build

windows: select_windows build

windows_arm: select_windows select_arm build

linux: build

linux_arm: select_arm build


format:
	gofmt -s -w ./

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${OS} GOARCH=${ARCH} go build -v -o kbot -ldflags "-X="github.com/svolkov/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${OS}

image:
	docker build . -t ${TAG}

clean:
	docker rmi ${TAG}