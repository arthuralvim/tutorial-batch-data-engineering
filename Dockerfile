FROM amazonlinux:2
MAINTAINER arthuralvim

ENV WORKDIR=/var/task \
    PIPENV_VENV_IN_PROJECT=1 \
    PYTHON_VERSION=3.7.0 \
    PIP_VERSION=19.3.1 \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    S3_INPUT=s3://bucket-example \
    DEBUG=True

ENV PYENV_ROOT $WORKDIR/.pyenv
ENV PIPENV_CACHE_DIR $WORKDIR/.pipenv
ENV PIPENV_PYTHON ${PYENV_ROOT}/shims/python
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
ENV BUILD_PACKAGES bzip2-devel gcc git wget which make \
                   openssl-devel python37-dev readline-devel postgresql-devel \
                   libffi-devel sqlite-devel tar

WORKDIR ${WORKDIR}
COPY . "$WORKDIR"

RUN yum install -y ${BUILD_PACKAGES} && \
    git clone git://github.com/yyuu/pyenv.git .pyenv && \
    pyenv install ${PYTHON_VERSION} && \
    pyenv global ${PYTHON_VERSION} && \
    pyenv rehash && \
    pip install --upgrade pip==${PIP_VERSION} && \
    pip install pipenv --no-cache-dir && \
    pipenv install --deploy && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    rm -rf ${PIPENV_CACHE_DIR}

RUN if test "$(S3_INPUT)" = "" ; then echo "S3_INPUT is undefined."; else aws s3 cp ${S3_INPUT} ${WORKDIR}/input/; fi

CMD ["pipenv", "run", "python", "run.py"]
