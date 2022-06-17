## 宝塔5.9本地化安装
所有文件均为download.bt.cn下载无修改版本，存档时间为2022/06/17

### CentOS安装
```
# 下载安装脚本，替换下载地址到github，安装面板
wget -O install.sh https://github.com/hjh142857/scripts/raw/master/bt59/install/install.sh
sed -i '/download_Url=/adownload_Url="https://raw.githubusercontent.com/hjh142857/scripts/master/bt59"' install.sh
sh install.sh

# 升级Pro版，同样是替换下载地址到github再运行脚本
wget -O update.sh https://github.com/hjh142857/scripts/raw/master/bt59/install/update_pro.sh
sed -i '/download_Url=/adownload_Url="https://raw.githubusercontent.com/hjh142857/scripts/master/bt59"' update.sh
bash update.sh pro
```

### Debian/Ubuntu安装
```
# 第一步下载install.sh脚本，后续步骤和CentOS一样
wget -O install.sh https://github.com/hjh142857/scripts/raw/master/bt59/install/install-ubuntu.sh
```