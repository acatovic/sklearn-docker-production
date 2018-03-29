FROM alpine:3.3

RUN apk add --no-cache curl tar && \
    curl -o /usr/bin/tini \
         -sSL https://github.com/krallin/tini/releases/download/v0.16.1/tini-static && \
    chmod +x /usr/bin/tini && \
    echo "http://dl-8.alpinelinux.org/alpine/edge/community" >> \
         /etc/apk/repositories && \
    apk add --update --no-cache binutils gcc gfortran python python-dev \
        py-pip py-setuptools build-base freetype-dev libpng-dev \
        openblas-dev && \
    pip install --upgrade pip && \
    pip install numpy scipy scikit-learn && \
    mkdir -p /tmp/sklearn/ && \
    cp /usr/lib/libopenblas.so.3 /tmp/sklearn/ && \
    cp /usr/lib/libgfortran.so.3 /tmp/sklearn/ && \
    cp /usr/lib/../lib/libquadmath.so.0 /tmp/sklearn/ && \
    cp /usr/lib/../lib/libgcc_s.so.1 /tmp/sklearn/ && \
    cp /usr/lib/libstdc\+\+.so.6 /tmp/sklearn/ && \
    strip -s /usr/bin/tini && \
    for lib in `find /usr/lib/* -type f -name *.so`; do strip -s $lib; done && \
    for lib in `find /tmp/sklearn/* -type f -name *.so`; do strip -s $lib; done && \
    apk del --purge curl tar binutils gcc gfortran build-base openblas-dev \
        py-pip python-dev libpng libpng-dev freetype-dev freetype libgcc \
        libstdc++ && \
    mv /tmp/sklearn/* /usr/lib/ && \
    rm -rf /tmp/sklearn/ && \
    rm -rf /usr/lib/python2.7/site-packages/*dist-info/ && \
    rm -rf /usr/lib/python2.7/site-packages/*egg-info/ && \
    for dir in `find /usr/lib/python2.7/site-packages/* -type d -name tests`; do rm -rf $dir; done && \
    for dir in `find /usr/lib/python2.7/site-packages/* -type d -name doc*`; do rm -rf $dir; done && \
    rm -rf /share/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/

ENTRYPOINT ["/usr/bin/tini", "--"]
