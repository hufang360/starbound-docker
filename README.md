本项目只是开源打包方法，相关文件和程序版权属于starbound原公司！！！

本项目只是开源打包方法，相关文件和程序版权属于starbound原公司！！！

本项目只是开源打包方法，相关文件和程序版权属于starbound原公司！！！

起因：找了下starbound的docker，发现都需要输入steam账号和密码，由于starbound已经好几年没更新了（后续应该没更新了），starbound开服是不需要验证steam账号的，所以想做一个docker镜像给自己开服用。
starbound是要购买的，我想这也是这些docker镜像，不打包本地的原因吧。

初次打包有 1.3G 左右，多次测试下，删除了不必要的文件，只是方便自己开服和玩家们开服，剔除开服所需之外的文件，这样这个包只能用于开服，而无法游玩。


### 快速启动

创建容器
```shell
docker pull hufang360/starbound-server:1.4.4

docker run --name starbound -it \
  -p 21025:21025 \
  -d hufang360/starbound-server:1.4.4
```

服务器开放`21025`端口，就可以联机了。


映射存档和mod目录
```shell
# 创建容器
docker run --name starbound -t \
  -p 21025:21025 \
  -v ./s1/mods:/mods \
  -v ./s1/storage:/storage \
  -d hufang360/starbound-server:1.4.4
```
注意：如果自定义了mods目录，记得重新添加汉化mod，因为映射后，就不再使用容器里的mod了。当然你可以从容器里面拷出这个汉化mod。


进入starbound的控制台界面。据我所知starbound的控制台好像不能输入指令，但是按 Ctrl+C 可以关服。
```shell
# 连接到容器的控制台
docker attach starbound
# 操作完成后，连续按下 Ctrl+P 和 Ctrl+Q 退出（starbound并不会因此而关服）

# 按 Ctrl+C 关服

# 也可以用docker的关服指令
docker stop starbound
```

进入后是空白状态，可以按下enter键，有新玩家加入，在这里就能看到了。
如果你想查看控制台的部分“历史记录”，可以输入
```shell
docker logs starbound
```


### 再次创建容器
学习阶段，我们会多次创建容器，此时就要关闭或处理上次的容器。
删除容器时，一定要先停止，不然有时会删除失败。
```shell
# 停止容器
docker stop starbound

# 删除容器
docker remove starbound
```



### 开发
由于 `packed.pak` 的文件大小超过100mb，无法作为源代码上传，请下载 [client.tar](https://github.com/hufang360/starbound-docker/releases/download/0.1/client.tar)，解压到当前目录使用。


**`client`文件列表：**
```shell
.
├── assets
│   └── packed.pak  # 做了精简
├── linux
│   ├── sbinit.config
│   └── starbound_server
└── mods
    └── starcore.pak  # 汉化
```

使用的是 “星核汉化组 简体中文”，创意工坊链接是：https://steamcommunity.com/sharedfiles/filedetails/?id=807695810

```shell
# 构建镜像
docker build -t starbound-server:1.4.4 .

# 打包指令，mac m1芯片
docker buildx build --platform linux/amd64 -t starbound-server:1.4.4 .

# 导出镜像文件
docker save -o ./starbound-server@1.4.4.tar starbound-server:1.4.4
```

同时打包`amd64`和`arm64`，并发布到dockerhub上。
```shell
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 -t hufang360/starbound-server:1.4.4 --push .
```