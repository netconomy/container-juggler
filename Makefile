test:
	CGO_ENABLED=0 go test -cover -v $(shell go list ./... | grep -v /cmd/)
build:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o ./bin/container-juggler-darwin-amd64
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -o ./bin/container-juggler-darwin-arm64
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./bin/container-juggler-linux-amd64
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o ./bin/container-juggler-win64.exe

