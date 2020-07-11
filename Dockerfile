############################
# STEP 1 build executable binary
############################
FROM golang:alpine AS builder
# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git

# Install dependencies
ENV GO111MODULE=on
WORKDIR $GOPATH/src/packages/goginapp/
COPY . .

# Fetch dependencies.
# Using go get.
RUN go get -d -v

# Build the binary.
RUN go build -o /go/bin/goginapp
RUN go build -o app

RUN if test -e "go.mod"; then go build ./...; fi

############################
# STEP 2 build a small image
############################
FROM scratch
# Copy our static executable.
COPY --from=builder /go/bin/goginapp /go/bin/goginapp

ENV PORT 8080
ENV GIN_MODE release
EXPOSE 8080

# Run the hello binary.
ENTRYPOINT ["/go/bin/goginapp"]
