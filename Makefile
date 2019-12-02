# Makefile batch-data-engineering

# These targets are not files
.PHONY: all help check.test_path requirements clean pep8 test test.dev test.failfirst test.collect test.skip.covered coverage coverage.html coveralls docker.login docker.build_ docker.tag docker.build docker.push

all: help

help:
	@echo 'Makefile *** batch-data-engineering *** Makefile'

check.test_path:
	@if test "$(TEST_PATH)" = "" ; then echo "TEST_PATH is undefined. The default is tests."; fi

requirements:
	@pipenv lock --requirements > requirements.txt

clean:
	@find . -name '*.pyc' -exec rm -f {} \;
	@find . -name 'Thumbs.db' -exec rm -f {} \;
	@find . -name '*~' -exec rm -f {} \;

pep8:
	@pycodestyle --filename="*.py" .

### TESTS

test: check.test_path
	@py.test -s $(TEST_PATH) --cov --cov-report term-missing --basetemp=tests/media --disable-pytest-warnings

test.dev: check.test_path
	@py.test -s $(TEST_PATH) --cov --cov-fail-under 70 --cov-report term-missing --basetemp=tests/media --disable-pytest-warnings

test.failfirst: check.test_path
	@py.test -s -x $(TEST_PATH) --basetemp=tests/media --disable-pytest-warnings

test.collect: check.test_path
	@py.test -s $(TEST_PATH) --basetemp=tests/media --collect-only --disable-pytest-warnings

test.skip.covered: check.test_path
	@py.test -s $(TEST_PATH) --cov --cov-report term:skip-covered --doctest-modules --basetemp=tests/media --disable-pytest-warnings

coverage: check.test_path test

coverage.html: check.test_path
	@py.test -s $(TEST_PATH) --cov --cov-report html --doctest-modules --basetemp=tests/media --disable-pytest-warnings

coveralls: coverage
	@coveralls

### DOCKER
DOCKER_REGISTRY := 296022280050.dkr.ecr.us-east-1.amazonaws.com
DOCKER_NAME := arthuralvim/tutorial-batch-data-engineering
DOCKER_TAG := $$(if [ "${TRAVIS_TAG}" = "" ]; then echo `git log -1 --pretty=%h`; else echo "${TRAVIS_TAG}"; fi)
DOCKER_IMG_TAG := ${DOCKER_NAME}:${DOCKER_TAG}
DOCKER_LATEST := ${DOCKER_NAME}:latest
DOCKER_PR_BRANCH := ${DOCKER_NAME}:${TRAVIS_PULL_REQUEST_BRANCH}

check.docker_registry:
	@if test "$(DOCKER_REGISTRY)" = "" ; then echo "DOCKER_REGISTRY is undefined."; exit 1; fi

docker.login:
	$$(aws ecr get-login --no-include-email --region us-east-1)

docker.build_: check.docker_registry
	@echo "Build started on `date`"
	@docker build -f Dockerfile -t ${DOCKER_IMG_TAG} .
	@echo "Build completed on `date`"

docker.tag: check.docker_registry
	@if [ ! -z "${TRAVIS_PULL_REQUEST_BRANCH}" ]; then docker tag ${DOCKER_IMG_TAG} ${DOCKER_REGISTRY}/${DOCKER_PR_BRANCH}; fi
	@docker tag ${DOCKER_IMG_TAG} ${DOCKER_REGISTRY}/${DOCKER_LATEST}
	@docker tag ${DOCKER_IMG_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMG_TAG}

docker.build: docker.build_ docker.tag

docker.push: check.docker_registry
	@echo "Pushing images started on `date`"
	@if [ ! -z "${TRAVIS_PULL_REQUEST_BRANCH}" ]; then docker push ${DOCKER_REGISTRY}/${DOCKER_PR_BRANCH}; fi
	@docker push ${DOCKER_REGISTRY}/${DOCKER_LATEST}
	@docker push ${DOCKER_REGISTRY}/${DOCKER_IMG_TAG}
	@echo "Pushing images completed on `date`"
