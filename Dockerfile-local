# 指定基础镜像，是的有它就不用安装依赖了
FROM ubuntu:18.04

# 定义挂载点
VOLUME ["/server", "/storage", "/mods"]

# 拷贝文件
COPY client/assets/packed.pak /server/assets/packed.pak
COPY client/linux/starbound_server /server/linux/starbound_server
COPY client/mods/starcore.pak /mods/starcore.pak
RUN echo '{"assetDirectories":["../assets/","/mods/"],"storageDirectory":"/storage/"}' > sbinit.config

# 指定容器监听端口
EXPOSE 21025

# 设置工作目录
WORKDIR /server/linux

# 启动命令
CMD ["./starbound_server"]