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

- This Starter Kit has been optimised for deployment into OpenShift using the [IBM Cloud Native Toolkit](https://cloudnativetoolkit.dev/) install this before following instructions
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
{select golang-pipeline pipeline}
```

View your Tekton pipelines in the Developer 

```bash
oc dashboard
```
Click on Pipelines and then switch to Developer view and click on Pipelines to see the pipeline running

## Deploy to IBM Edge Application Manager

The following steps assist you in the deployment of the edge app to the IBM Edge Application Manager.

### Install HZN CLI MacOS

```
wget http://pkg.bluehorizon.network/macos/certs/horizon-cli.crt
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain horizon-cli.crt
sudo installer -pkg horizon-cli-2.24.18.pkg -target / -allowUntrusted
```
### Install HZN CLi Linux

```bash
arch=$(dpkg --print-architecture)
dist=bionic
version=2.26.12
wget http://pkg.bluehorizon.network/linux/ubuntu/pool/main/h/horizon/bluehorizon_${version}~ppa~ubuntu.${dist}_all.deb
wget http://pkg.bluehorizon.network/linux/ubuntu/pool/main/h/horizon/horizon-cli_${version}~ppa~ubuntu.${dist}_${arch}.deb
wget http://pkg.bluehorizon.network/linux/ubuntu/pool/main/h/horizon/horizon_${version}~ppa~ubuntu.${dist}_${arch}.deb
dpkg -i horizon-cli_${version}~ppa~ubuntu.${dist}_${arch}.deb
dpkg -i horizon_${version}~ppa~ubuntu.${dist}_${arch}.deb
dpkg -i bluehorizon_${version}~ppa~ubuntu.${dist}_all.deb
```

### Build and Register the Edge App 

Log into your Edge Management cluster and define these variables
Configure the following properties before publishing the Service information to the Edge server

```bash
export APIKEY=<api-key>
export HZN_EXCHANGE_URL=https://$(oc get routes icp-console -o jsonpath='{.spec.host}' -n kube-system)/edge-exchange/v1
export EXCHANGE_ROOT_PASS=$(oc -n kube-system get secret ibm-edge-auth -o jsonpath="{.data.exchange-root-pass}" | base64 --decode)
HZN_EXCHANGE_USER_AUTH="root/root:$EXCHANGE_ROOT_PASS"
export HZN_ORG_ID=IBM
```

Trust your exchange server with your Development environment on MacOS

Extract the certificate from teh Edge Application Manager

```bash
oc --namespace kube-system get secret cluster-ca-cert -o jsonpath="{.data['tls\.crt']}" | base64 --decode > /tmp/icp-ca.crt
```

Register the certificate into MacOS Key Chain

```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /tmp/icp-ca.crt
```

Register the certificate into Linux Chain

```bash
sudo cp /tmp/icp-ca.crt /usr/local/share/ca-certificates && sudo update-ca-certificates
```

Create your Signing Key pair the local registration will be trusted, you can use your org name and email address

```bash
hzn key create "IBM" "mjperrin@us.ibm.com"
```

Login to the IBM Image Registry using `docker login`
```bash
docker login -u iamapikey -p ${APIKEY} us.icr.io
```

To publish the service definition, and the deployment policy to the Edge Manager run the following command

```bash
docker login -u iamapikey -p $APIKEY us.icr.io
```

Publish the Edge Device Service

```bash
make publish-service
```

### Configuring Edge CD with Tekton on Red Hat OpenShift

The first step is to extract the key meta data from the IBM Edge Application Manager Cluster and save this into a secret.

This secret then needs to be registered into your Red Hat OpenShift development project namespace on the cluster that you are using for development. This may be different to the cluster that the IBM Edge Application Manager has been installed into. This will enable a new Tekton task called `edge-cd` to be used in your pipeline to dynamically register the built image as a Service directly with IBM Edge Application Manager.   

To extract this information first log into the IBM Edge Application Manager on the command line. Then run `./build-secret.sh` to create the secret YAML definition `edge-access-secret.yaml`.  

```
./build-secret.sh
``` 

Check the secret has been created in your file system and the data inside the secret is as expected. The secret is added to the `.gitignore` so will not be checked into your GIT repository. 

Next step is to log into your development cluster on the command line and register the secret into the project/namespace you are building the Go Gin Edge 
application. Once logged in run this `kubectl` command to register the secret.  

```bash
kubectl apply -f edge-access-secret.yaml
```

The Edge Tasks are now included in the [IBM Garage Cloud Native Toolkit](https://cloudnativetoolkit.dev/) in the [Garage Tekton Tasks repository](https://github.com/IBM/ibm-garage-tekton-tasks/tree/v1.27.0) these are automatically installed with the toolkit, you can upgrade them if newer releases are published.

Final part is create a repo from this template into your own repo in your own git organization. Then clone the code and register pipeline with OpenShift and Tekton.

Register the pipeline with Tekton
```bash
oc sync dev-edge --dev
oc pipeline
{select the `golang-pipeline-edge` pipeline}
```

Enjoy the end to end CI/CD with Tekton and IBM Edge Application Manager

## Next steps

* Learn more about augmenting your Go applications on IBM Cloud with the [Go Programming Guide](https://cloud.ibm.com/docs/go?topic=go-getting-started).
* Explore other [sample applications](https://cloud.ibm.com/developer/appservice/starter-kits) on IBM Cloud.

## License

This sample application is licensed under the Apache License, Version 2. Separate third-party code objects invoked within this code pattern are licensed by their respective providers pursuant to their own separate licenses. Contributions are subject to the [Developer Certificate of Origin, Version 1.1](https://developercertificate.org/) and the [Apache License, Version 2](https://www.apache.org/licenses/LICENSE-2.0.txt).

[Apache License FAQ](https://www.apache.org/foundation/license-faq.html#WhatDoesItMEAN)
