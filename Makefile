REGISTRY=ghcr.io/svolkov
APP=$(shell basename $(shell git remote get-url origin))
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
OS=linux
ARCH=amd64

select_arm:
	$(eval ARCH=arm)

select_arm64:
	$(eval ARCH=arm64)

select_windows:
	$(eval OS=windows)

select_macos:
	$(eval OS=darwin)

format:
	gofmt -s -w ./

get:
	go get

lint:
	go lint

test:
	go test -v

build_for_macos: select_macos build

build_for_macos_arm64: select_macos select_arm64 build

build_for_windows: select_windows build

build_for_windows_arm: select_windows select_arm build

build_for_linux: build

build_for_linux_arm: select_arm build

build: format get
	CGO_ENABLED=0 GOOS=${OS} GOARCH=${ARCH} go build -v -o kbot -ldflags "-X="github.com/svolkov/kbot/cmd.appVersion=${VERSION}

image_for_macos: select_macos image

image_for_macos_arm64: select_macos select_arm64 image

image_for_windows: select_windows image

image_for_windows_arm: select_windows select_arm image

image_for_linux: image

image_for_linux_arm: select_arm image

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${OS}-${ARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${OS}-${ARCH}

clean_image_macos: select_macos clean

clean_image_macos_arm64: select_macos select_arm64 clean

clean_image_windows: select_windows clean

clean_image_windows_arm: select_windows select_arm clean

clean_image_linux: clean

clean_image_linux_arm: select_arm clean

clean:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${OS}-${ARCH}