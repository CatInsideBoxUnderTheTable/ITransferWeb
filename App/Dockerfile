FROM golang:latest

WORKDIR /app

COPY ./src/ .

RUN go build -o transferWeb

ENV APP_PORT="9000"

EXPOSE 9000 

CMD ["./transferWeb"]
