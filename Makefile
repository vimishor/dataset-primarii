ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
TEST_ARGS ?= "--src=$(ROOT_DIR)/data"
BUILD_DIR := $(ROOT_DIR)/build
DIST_DIR := $(ROOT_DIR)/dist
GIT_VERSION := "nightly"

ifneq ($(wildcard $(ROOT_DIR)/.git/.*),)
	GIT_VERSION := $(shell git describe --abbrev=6 --dirty --always --tags)
endif

install-deps:
	@pip3 install --upgrade -r $(ROOT_DIR)/requirements.txt

test:
	@$(ROOT_DIR)/test/runtests.py $(TEST_ARGS)

dist: clean
	@mkdir -p $(BUILD_DIR)/primarii $(DIST_DIR)
	@cp -r $(ROOT_DIR)/data $(BUILD_DIR)/primarii/data
	@cp -f $(ROOT_DIR)/LICENSE.md $(ROOT_DIR)/README.md $(BUILD_DIR)/primarii
	@cd $(BUILD_DIR); tar zcf $(DIST_DIR)/primarii-$(GIT_VERSION).tar.gz primarii/

clean:
	@rm -rf $(BUILD_DIR) $(DIST_DIR)

.PHONY: clean test dist
