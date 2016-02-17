eval $(docker-machine env dev)
docker build --rm --no-cache -f docker/ubuntu -t ubuntu:stns_test . && \
docker run -t ubuntu:stns_test && \
docker build --rm --no-cache -f docker/rhel -t centos:stns_test . && \
docker run -t centos:stns_test
