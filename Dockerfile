# build env
FROM node:13.12.0-alpine as build
WORKDIR /app

# install git
RUN apk update && apk upgrade && \
    apk add --no-cache git

COPY ./client /app/
RUN yarn install --ignore-engines
RUN yarn build

# production env
FROM golang:alpine
WORKDIR /app
COPY go.*  /app/
COPY *.go /app/
COPY .env /app/
COPY --from=build /app/ /app/client

RUN go mod download
RUN go build -o /app/serve

ENV GIN_MODE=release
EXPOSE 8080

ENTRYPOINT ["./serve"]