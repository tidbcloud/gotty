FROM golang AS gotty
WORKDIR /root
RUN git clone https://github.com/kolbe/gotty
WORKDIR gotty
RUN go build -a -o /

FROM ubuntu:18.04
RUN apt-get update && apt-get upgrade -y && apt-get install -y mysql-client less vim

COPY --from=gotty /gotty /
ADD client-loop /client-loop
RUN chmod +x /client-loop

EXPOSE 7681

ENTRYPOINT ["/gotty","-w"]
CMD ["/client-loop"]
