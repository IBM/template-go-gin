<p align="center">
    <a href="http://kitura.io/">
        <img src="https://landscape.cncf.io/logos/ibm-member.svg" height="100" alt="IBM Cloud">
    </a>
</p>


<p align="center">
    <a href="https://cloud.ibm.com">
    <img src="https://img.shields.io/badge/IBM%20Cloud-powered-blue.svg" alt="IBM Cloud">
    </a>
    <img src="https://img.shields.io/badge/platform-go-lightgrey.svg?style=flat" alt="platform">
    <img src="https://img.shields.io/badge/license-Apache2-blue.svg?style=flat" alt="Apache 2">
</p>

# Go Edge, Microservice or Backend for Frontend with Gin

This **Go** Starter Kit Template can be the foundation for an Edge , Cloud-Native Microservice or a Backend for Frontend solution.

## Features

The starter kit provides the following features:

- Built with [Go](https://golang.org/dl/)
- REST services using [Gin](https://github.com/gin-gonic/gin)
- Swagger documentation using [Swagger UI](https://swagger.io/docs/open-source-tools/swagger-ui/usage/installation/)
- Testing Framework with [Go Test](https://golang.org/pkg/testing/)
- Experience Testing with Selenium [UI Test](scripts/README.md)
- Jenkins DevOps pipeline that support OpenShift or IKS deployment

In this sample web application, you will create a Go cloud application using Gin. This application contains an opinionated set of files for web serving:

- `public/index.html`
- `public/404.html`
- `public/500.html`

This application also enables a starting place for a Go microservice using Gin. A microservice is an individual component of an application that follows the **microservice architecture** - an architectural style that structures an application as a collection of loosely coupled services, which implement business capabilities. The microservice exposes a RESTful API matching a [Swagger](http://swagger.io) definition.

You can start to extend the Starter Kit by adding new **API Endpoints** in the `routers` directory.

## Steps

You can [build it locally](#building-locally) by cloning this repo first using the template feature in git. After your app is live, you can access the `/health` endpoint to build out your cloud native application.

Also, this application comes with the following capabilities:
- [Swagger UI](http://swagger.io/swagger-ui/) running on: `/explorer`
- An OpenAPI 2.0 definition hosted on: `/swagger/api`
- A Healthcheck: `/health`

### Building locally

To get started building this web application locally, you can either run the application natively or use the [IBM Cloud Developer Tools](https://cloud.ibm.com/docs/cli?topic=cloud-cli-getting-started) for containerization and easy deployment to IBM Cloud.

All of your `go` dependencies are listed in `go.mod`.

#### Native application development

- Install [Go](https://golang.org/dl/)

In order for Go applications to run anywhere including your $GOPATH/src
```
export GO111MODULE=on
```

Fetch and install dependencies listed in go.mod:
```bash
go build ./...
```

To run your application locally:
```bash
go run server.go
```

Your sources will be compiled to your `$GOPATH/bin` directory. Your application will be running at `http://localhost:8080`. You can also verify the state of your locally running application using the Selenium UI test script included in the `scripts` directory.


#### Local Development with Docker

To build the application into a local docker image you need to have the [Docker Desktop](https://www.docker.com/products/docker-desktop) installed  

Run the following command to build it into a versioned package 
```
./build
```
To run locally 
```
./run
```

To boostrap into the running image run the following command 
```
docker run -it --entrypoint /bin/sh -p 8080:8080 template-go-gin:1.0.1
```

### Deploying to Red Hat OpenShift 

Make sure you are logged into the IBM Cloud using the IBM Cloud CLI and have access 
to your OpenShift development cluster.

```$bash
oc login
oc get pods
npm install -g @ibmgaragecloud/cloud-native-toolkit-cli
git clone <code pattern> | cd <code pattern>

```

Register the GIT Repo with Tekton or Jenkins CI engine 
```$bash
oc sync <project> --dev
oc pipeline 
```

View your Tekton pipelines in the Developer 

```bash
oc dashboard
```

## Deploy to IBM Edge Application Manager

The following steps assist you in the deployment of the 

### Install HNZ CLI

```
wget http://pkg.bluehorizon.network/macos/certs/horizon-cli.crt
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain horizon-cli.crt
sudo installer -pkg horizon-cli-2.24.18.pkg -target / -allowUntrusted
```

Configure the following properties before publishing the Service information to the Edge server
```bash
export CLOUD_API_KEY=<api-key>
export HZN_EXCHANGE_USER_AUTH=iamapikey:<api-key>
export HZN_EXCHANGE_URL=<url of Edge Manager>/edge-exchange/v1/
```

Create your Signing Key Pair

```bash
 hzn key create "IBM" "mjperrin@us.ibm.com"
```

Login to the IBM Image Registry using `docker login`
```bash
docker login -u iamapikey -p <api-key> us.icr.io
```

To publish the service definition, and the deployment policy to the Edge Manager run the following command

```bash
export CLOUD_API_KEY={IBMCLOUD_API_KEY}
export HZN_EXCHANGE_USER_AUTH=iamapikey:{IBM_CLOUD_API_KEY
export HZN_EXCHANGE_URL=https://icp-console.edge-computing-ocp43-3b1fc50af0b2002f0241bdf5d2432efd-0000.us-east.containers.appdomain.cloud/edge-exchange/v1/

docker login -u iamapikey -p $CLOUD_API_KEY us.icr.io

```

Publish the Edge Device Service

```bash
make publish-service
```

## Next steps
* Learn more about augmenting your Go applications on IBM Cloud with the [Go Programming Guide](https://cloud.ibm.com/docs/go?topic=go-getting-started).
* Explore other [sample applications](https://cloud.ibm.com/developer/appservice/starter-kits) on IBM Cloud.

## License

This sample application is licensed under the Apache License, Version 2. Separate third-party code objects invoked within this code pattern are licensed by their respective providers pursuant to their own separate licenses. Contributions are subject to the [Developer Certificate of Origin, Version 1.1](https://developercertificate.org/) and the [Apache License, Version 2](https://www.apache.org/licenses/LICENSE-2.0.txt).

[Apache License FAQ](https://www.apache.org/foundation/license-faq.html#WhatDoesItMEAN)
