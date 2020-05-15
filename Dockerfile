FROM golang AS gotty
WORKDIR /root
RUN git clone https://github.com/kolbe/gotty
WORKDIR gotty
RUN go build -a -o /

FROM ubuntu:18.04
COPY --from=gotty /gotty /
RUN apt-get update \
    && apt-get install -y \
       less \
       libreadline5 \
       mysql-client-5.7 \
    && rm -rf /var/lib/apt/lists/*

ADD client-loop /client-loop
RUN chmod +x /client-loop

EXPOSE 7681

ENTRYPOINT ["/gotty","-w"]
CMD ["/client-loop"]
