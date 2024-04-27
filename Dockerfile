FROM ubuntu:18.04
COPY client/ /opt/starbound
WORKDIR /opt/starbound/linux
EXPOSE 21025
CMD ["./starbound_server"]