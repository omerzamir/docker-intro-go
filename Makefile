# Binary names
BINARY_NAME=docker-intro-go

.PHONY: all build clean run docker-build docker-run docker-stop docker-remove

all: clean build run
build:
		CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $(BINARY_NAME) -v
clean:
		go clean
		sudo rm -rf $(BINARY_NAME)
run: build
		./$(BINARY_NAME)
docker-build:
		docker build -t docker-intro-go:latest .
docker-run:
		docker run -p 4444:4444 --name docker-intro-go -d docker-intro-go:latest
docker-stop:
		docker stop docker-intro-go
docker-remove:
		docker rm --force docker-intro-go