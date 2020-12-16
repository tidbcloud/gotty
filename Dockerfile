FROM golang AS gotty
WORKDIR /root
RUN git clone https://github.com/tidbcloud/gotty
RUN cd gotty && go build -o /
WORKDIR /root
RUN git clone github.com/tidbcloud/usql
RUN cd usql && GO111MODULE=on go build -tags 'no_sqlite3' -o /

FROM ubuntu:18.04
COPY --from=gotty /gotty /
COPY --from=gotty /usql /bin/usql
RUN chmod +x /bin/usql
ADD client-loop /client-loop
RUN chmod +x /client-loop

EXPOSE 7681

ENTRYPOINT ["/gotty","-w"]
CMD ["/client-loop"]
