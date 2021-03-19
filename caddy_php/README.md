## Debian10下一键安装Caddy-1.0.4 + PHP-7.3
鉴于caddy2配置太复杂，而caddy1的官方安装脚本已经失效，所以从历史docker镜像中提取出了caddy1最后一个版本1.0.4的x86 Linux下的文件，MD5为`036abefc6dc88c9e9a7493e1846211f3`，然后编写了一个脚本用于快速搭建一个简单的PHP Web环境

## 注意
需要先设置好域名解析，否则caddy无法自动申请SSL证书

## 使用
```
wget -qO- git.io/miniweb | bash -s your_domain.com
```

## 参考的源码
> [dylanbai8/Onekey_Caddy_PHP7_Sqlite3](https://github.com/dylanbai8/Onekey_Caddy_PHP7_Sqlite3)   
> [Caddyserver官方Wiki](https://github.com/caddyserver/caddy/wiki/Caddy-as-a-service-examples)
