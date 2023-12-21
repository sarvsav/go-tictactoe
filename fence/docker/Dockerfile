FROM golang:1.21 AS builder

LABEL maintainer="Sarvsav Sharma <codingtherightway@gmail.com>" \
      version="1.0" \
      description="Your description here" \
      org.opencontainers.image.url="https://example.com/project" \
      org.opencontainers.image.source="https://github.com/yourusername/yourrepository" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.vendor="Your Company" \
      org.opencontainers.image.documentation="https://example.com/docs" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="abcdef123456" \
      org.opencontainers.image.architecture="amd64"

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download && go mod tidy && go mod vendor

RUN go generate

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o bin/tictactoe .

FROM scratch

WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/bin/tictactoe .

# Command to run the executable
CMD ["./tictactoe"]
