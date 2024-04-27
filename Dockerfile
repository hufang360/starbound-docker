# 指定基础镜像，是的有它就不用安装依赖了
FROM ubuntu:18.04

# 定义挂载点
VOLUME ["/server", "/storage", "/mods"]

# 处理开服文件
RUN apt-get update \
 && apt-get install -y wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && cd / \
 && wget https://github.com/hufang360/starbound-docker/releases/download/0.1/client.tar \
 && tar -xvf client.tar \
 && rm client.tar \
 && rm -rf /server \
 && mv /client /server \
 && mkdir -p /mods \
 && mv /server/mods/starcore.pak /mods/starcore.pak  \
 && echo '{"assetDirectories":["../assets/","/mods/"],"storageDirectory":"/storage/"}' > /server/linux/sbinit.config

 # 指定容器监听端口
EXPOSE 21025

# 设置工作目录
WORKDIR /server/linux

# 启动命令
CMD ["./starbound_server"]