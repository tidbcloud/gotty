FROM golang AS gotty
WORKDIR /root
RUN git clone https://github.com/tidbcloud/gotty
WORKDIR gotty
RUN go build -a -o /
RUN go get -u -tags 'no_sqlite3' github.com/tidbcloud/usql

FROM ubuntu:18.04
COPY --from=gotty /gotty /
COPY --from=gotty /go/bin/usql /bin/usql
RUN chmod +x /bin/usql
ADD client-loop /client-loop
RUN chmod +x /client-loop

EXPOSE 7681

ENTRYPOINT ["/gotty","-w"]
CMD ["/client-loop"]
