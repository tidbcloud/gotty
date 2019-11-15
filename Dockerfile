FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y mysql-client less vim

ADD gotty /gotty
RUN chmod +x /gotty

ADD client-loop /client-loop
RUN chmod +x /client-loop

EXPOSE 7681

ENTRYPOINT ["/gotty","-w"]
CMD ["/client-loop"]
