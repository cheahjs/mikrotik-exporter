FROM golang:1.16-buster as build

ARG shortSHA=dummy

WORKDIR /go/src/app
ADD . /go/src/app

RUN go get -d -v ./...
RUN go build \
    -ldflags "-X main.appVersion=$(cat VERSION) -X main.shortSha=${shortSHA}" \
    -o /go/bin/app \
    .

FROM discolix/base:debug

COPY scripts/start.sh /app/
COPY --from=build /go/bin/app /app/mikrotik-exporter

EXPOSE 9436

ENTRYPOINT ["/app/start.sh"]
