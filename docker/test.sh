eval $(docker-machine env dev)
docker build -f docker/ubuntu -t ubuntu:stns_test .
docker build -f docker/rhel -t centos:stns_test .

docker run -t ubuntu:stns_test
docker run -t centos:stns_test
