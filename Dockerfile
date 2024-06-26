FROM golang:latest AS build-env
ADD ./  /prom2click
WORKDIR /prom2click
RUN go mod tidy &&  CGO_ENABLED=0 go build -ldflags "-X main.GitCommit=${GIT_COMMIT}${GIT_DIRTY} -X main.VersionPrerelease=DEV" -o bin/prom2click

FROM alpine
RUN apk add -U tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
COPY --from=build-env /prom2click/bin/prom2click /usr/local/bin/prom2click
RUN chmod +x /usr/local/bin/prom2click
CMD ["prom2click"]
