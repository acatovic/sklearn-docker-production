# sklearn-docker-production

docker build -t sklearn-alpine-production .

It takes time to build, so start the build and get a cup of coffee!

To run the container: docker run -it sklearn-alpine-production /bin/sh

NOTE: bash is not available in Alpine, use sh!