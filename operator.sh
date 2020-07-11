rm -rf operator
operator-sdk new operator --api-version=gsi.ibm.com/v1alpha1 \
    --kind=EdgeGoGateway \
    --type=helm
cd operator