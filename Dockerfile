#build stage
FROM golang:alpine AS builder
RUN apk add --no-cache git make
ENV GO111MODULE=on
WORKDIR /go/src/app
COPY go.mod ./
RUN go mod download
COPY . .
RUN make build

#final stage
FROM scratch
COPY --from=builder /go/src/app/docker-intro-go /docker-intro-go

EXPOSE 4444
ENTRYPOINT ["/docker-intro-go"]