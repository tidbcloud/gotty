FROM ubuntu:18.04 AS mysql-client
RUN sed -i 's/# \(deb-src .*\)$/\1/' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        git cmake gcc g++ gnutls-dev libncurses5-dev libcurl4-gnutls-dev \
    && git clone https://github.com/kolbe/mariadb-server --depth=1 --branch=tidb-client /client \
    && cd /client \
    && cmake . -DWITHOUT_SERVER=ON -DCPACK_STRIP_FILES=ON -DMYSQL_TCP_PORT=4000 \
    && make -j install \
    && rm -rf /client /var/lib/apt/lists/*



FROM golang AS gotty
WORKDIR /root
RUN git clone https://github.com/kolbe/gotty
WORKDIR gotty
RUN go build -a -o /



FROM ubuntu:18.04
COPY --from=gotty /gotty /
COPY --from=mysql-client /usr/local/mysql/bin/mysql /usr/local/bin
RUN apt-get update \
    && apt-get install -y \
       less \
       libreadline5 \
    && rm -rf /var/lib/apt/lists/*

ADD client-loop /client-loop
RUN chmod +x /client-loop

EXPOSE 7681

ENTRYPOINT ["/gotty","-w"]
CMD ["/client-loop"]
