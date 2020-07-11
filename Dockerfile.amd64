FROM golang:alpine

#RUN yum -y install --disableplugin=subscription-manager wget git \
#    && yum --disableplugin=subscription-manager clean all

# Grab go version 1.13
#RUN wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz

# Install go version 1.13
#RUN tar -C /usr/local -xzf go1.13.3.linux-amd64.tar.gz

# Setup go environment variables
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# Configure application working directories
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Change working directory
WORKDIR $GOPATH/src/goginapp/

# Install dependencies
ENV GO111MODULE=on
COPY . ./
RUN if test -e "go.mod"; then go build ./...; fi

ENV PORT 8080
ENV GIN_MODE release
EXPOSE 8080

RUN go build -o app
CMD ["./app"]