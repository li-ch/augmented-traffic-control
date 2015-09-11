# You must have a working go environment in order to build atc.
# See https://golang.org/doc/code.html

PROJECT = github.com/facebook/augmented-traffic-control
SRC = ${PROJECT}/src

TEST = go test -v
BUILD = go build
VET = @go vet
FMT = @go fmt
THRIFT = thrift

.PHONY: all
all: init bin/atcd bin/atc_api

bin/atcd: src/atc_thrift src/daemon/*.go src/atcd/*.go
	$(FMT) ${SRC}/daemon ${SRC}/atcd
	$(VET) ${SRC}/daemon ${SRC}/atcd
	$(TEST) ${SRC}/daemon ${SRC}/atcd
	$(BUILD) -o bin/atcd ${SRC}/atcd

bin/atc_api: src/atc_thrift src/api/*.go src/atc_api/*.go
	$(FMT) ${SRC}/api ${SRC}/atc_api
	$(VET) ${SRC}/api ${SRC}/atc_api
	$(TEST) ${SRC}/api ${SRC}/atc_api
	$(BUILD) -o bin/atc_api ${SRC}/atc_api

src/atc_thrift: if/atc_thrift.thrift
	$(THRIFT) --out src/ --gen go if/atc_thrift.thrift

.PHONY: init
init:
	mkdir -p bin/
	mkdir -p ${GOPATH}/src/${PROJECT}
	[ -h ${GOPATH}/src/${SRC} ] || ln -s $(shell pwd)/src ${GOPATH}/src/${SRC}

.PHONY: clean
clean:
	rm -rf bin/

.PHONY: fullclean
fullclean: clean
	rm -rf src/atc_thrift/
