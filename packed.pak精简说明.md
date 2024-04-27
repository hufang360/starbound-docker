完整的starbound有1G多。里面包括游戏启动程序和开服程序。心想服务端不需要渲染图形，删掉图片文件就变小了。
实际情况是删掉图片会报错，删掉声音文件倒是能清出不少文件。
做了一些尝试，比如用0字节的文本提到png图片、用1x1px的图片进行替换都失败，由于服务器看不到图片的样子，所以想到将图片上的像素全都清除，图片尺寸没变，就不会报错了，结果发现进能源副本会报错，这步其实可以减掉了118mb。
由于starbound内置解包和打包工具这一切变得很轻松。
下面 `packed.pak` 包的处理过程：

```shell
# 切换工作目录至游戏目录

# 备份 packed.pak
# 原始大小 861M
cp -f ./assets/packed.pak ./assets/packed.pak.bak

# 删除现有的，一会会重新打包
rm -f ./assets/packed.pak

# 创建解包目录
rm -rf ./unpack

# 解包
./linux/asset_unpacker ./assets/packed.pak.bak ./unpack

# 切换到解包目录
cd unpack

# 删除声音文件，-608mb
find . -type f -name "*.ogg" -exec rm -f {} \;

# 压缩json文件，-48mb，需要安装 jq
find . -type f -name "*.json" -exec sh -c 'jq -c . "{}" > tmpfile && mv tmpfile "{}"' \;

# 退出资源目录
cd ..

# 打包精简后的资源
./linux/asset_packer ./unpack ./assets/packed.pak

# 查看包文件大小
ls -lh ./assets/packed.pak
```


```shell
# 这样处理后，会进不了能源、叶族副本
# 清除图片上的像素 -118mb，需要安装 ImageMagick
find . -type f -name "*.png" -exec sh -c 'convert "{}" -alpha off -colorspace Gray -fill none -draw "color 0,0 reset" "{}"' \;
```