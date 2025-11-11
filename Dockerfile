# build stage
# golang:1.25.4-alpine
FROM golang@sha256:d3f0cf7723f3429e3f9ed846243970b20a2de7bae6a5b66fc5914e228d831bbb AS builder

# Create appuser
ENV USER=appuser
ENV UID=10001

RUN adduser \    
  --disabled-password \    
  --gecos "" \    
  --home "/appuser" \    
  --shell "/sbin/nologin" \       
  --uid "${UID}" \    
  "${USER}"

WORKDIR /go/src/app

RUN apk --update add ca-certificates

# sownload deps
COPY go.mod go.sum ./
RUN go mod download
RUN go mod verify

# copy code to build
COPY . .

# build static version, without cgo and debug symbols for the relevant arch
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o docker-intro-go -v ./cmd


# final stage 0MB image
FROM scratch

# copy user data
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder --chown=appuser:appuser /appuser /appuser
COPY --from=builder /usr/local/go/lib/time/zoneinfo.zip /
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

WORKDIR         /usr/src/app

# copy app's binary 
COPY --from=builder /go/src/app/docker-intro-go ./docker-intro-go

# Use an unprivileged user.
USER appuser:appuser

EXPOSE 4444

ENV ZONEINFO=/zoneinfo.zip

CMD ["./docker-intro-go"]
