# Description说明
本脚本和YML配置文件用于使用Azure的免费Web应用程序搭建自己的[开源密码管理程序Bitwarden_rs](https://github.com/dani-garcia/bitwarden_rs/)服务端，并定时备份到Web应用自带的存储空间，也可以备份到远程FTP，且程序启动自动还原数据，方便使用。

#### YML中环境变量说明
前五项为Bitwarden_rs自带的环境变量，后五项为自动备份脚本所需的变量。需要实现Bitwarden_rs的其他个性化设置可以参考官方[ENV列表](https://github.com/dani-garcia/bitwarden_rs/blob/master/.env.template)
```
* WEBSOCKET_ENABLED=true                     # 启用websocket，用于推送密码变化
* SIGNUPS_ALLOWED=true                       # 允许注册新用户，设置为false则禁止新注册
* WEB_VAULT_ENABLED=true                     # 用户web页面，设置为false则关闭
* ADMIN_TOKEN=your_web_admin_panel_password  # web管理员页面的密码，不设置则关闭管理面板，详细请阅读README
* DOMAIN=https://your_domain                 # 域名设置，免费F1计划域名格式为http://xxx.azurewebsites.net
* REALTIME_BAK_CYCLE=10                      # 定时备份间隔分钟数，需要能被60整除，设置为0则关闭所有备份（包括FTP备份）
* DAILY_BAK_COUNTS=5                         # FTP每日备份的保留份数，每天北京时间0时备份
* FTP_URL=ftp://your_ftp_url/your_folder/    # FTP备份地址，必须以/结尾，否则会出现错误。不设置本项则禁用远程FTP备份
* FTP_USER=your_ftp_username                 # FTP用户名，不启用远程FTP备份可以不设置
* FTP_PASS=your_ftp_password                 # FTP密码，不启用远程FTP备份可以不设置
```

#### Backup & Restore备份与还原
* 环境变量`REALTIME_BAK_CYCLE`为定时备份周期，该项必须设置成60的因数，否则可能会有BUG。若为0，则关闭所有备份功能。(eg. 若设置为12，则每小时的第12/24/36/48/60分钟进行备份)
* 定时备份的目录为`/home/site/wwwroot/bitwarden/backup_realtime`，保留24小时内的备份，可以通过[Usage使用](#Usage使用)中步骤5的Bash或Azure Web Service提供的FTP链接，都可以看到。
* 环境变量`DAILY_BAK_COUNTS`为FTP远程备份的保留份数，远程FTP备份每天北京时间0点进行，同时也可以在`/home/site/wwwroot/bitwarden/backup_daily`中看到
* 启动容器时会进行自动还原操作，优先还原`/home/site/wwwroot/bitwarden/backup_realtime`目录下的最新备份，若没有则检索`/home/site/wwwroot/bitwarden/backup_daily`目录下的最新备份进行还原
* 从FTP下载备份还原，下载完成后放到`/home/site/wwwroot/bitwarden/backup_daily`目录下并清空`backup_realtime`和`backup_daily`目录下其他所有备份，重新启动容器即可还原

#### Attention注意
* 当前免费的F1计划websocket有BUG暂时无法使用，正在解决中，参考[Azure官方文档](https://docs.microsoft.com/zh-cn/azure/app-service/containers/app-service-linux-faq#web-sockets)、[Github Issue](https://github.com/MicrosoftDocs/azure-docs/issues/49245)
* 如果需要自己注册完成后，禁止新用户注册，需要在`backup_realtime`中发现注册完成后的新备份之后，才能修改`SIGNUPS_ALLOWED`为false并重启容器
* 用户Web页面登录页面完整打开一次需要流量为6MB左右，而免费的F1计划日限额为165MB，当日流量用完后会导致服务不可访问（403错误），且APP端可以进行绝大部分日常必须的功能（包括注册），所以可以根据自身需求考虑是否需要关闭用户Web界面
* web管理员页面的网站为https://your_domain/admin，[Bitwarden_rs官方文档](https://github.com/dani-garcia/bitwarden_rs/wiki/Enabling-admin-page)推荐生成随机TOKEN的命令为`openssl rand -base64 48`
* 若绑定了多个域名，为保证最大兼容性环境变量`DOMAIN`可以不设置。域名不设置只会影响部分个人认为不常用的功能，具体可以查看[Bitwarden_rs官方wiki](https://github.com/dani-garcia/bitwarden_rs/wiki)和[环境变量说明](https://github.com/dani-garcia/bitwarden_rs/blob/master/.env.template)。但不设置域名会导致登录web管理员页面后自动跳转到localhost，可以通过手动把localhost改成域名解决，也可以直接网页后退然后再刷新页面。
* Azure免费的F1计划不能开启Always On功能，没有流量程序就会自动停止。请保持应用活跃。若使用付费计划，可以按照[Usage使用](#Usage使用)第四步启用始终可用(Always On)功能。

# Usage使用
1. 登录Azure，https://portal.azure.com/
2. 应用程序服务(App Service) - 添加(Add) - 输入名称(Name)，发布(Pubilsh)选中Docker，操作系统(Operating System)选Linux，区域(Region)按需选择，SKU和大小(Sku and size)选择免费的F1计划，直接查看并创建(Review + create)，再点击创建（Create）
3. 稍等几分钟部署完成后点击转入资源(Go to resource)
4. 修改一些环境配置
    * 侧边栏 设置Settings（配置Configuration）-> 应用程序设置Application settings -> *WEBSITES_ENABLE_APP_SERVICE_STORAGE* -> 值改为true，部署槽位设置不要勾选
    * 侧边栏 设置Settings（配置Configuration) -> 常规设置General settings -> Web套接字(web sockets)改为开On
    * 若使用付费计划，侧边栏 设置Settings（配置Configuration) -> 常规设置General settings -> 始终可用(Always On)改为开On
    * 点击保存Save -> 继续Continue
5. 侧边栏 开发工具Development Tools（高级工具Advanced Tools） - 转到Go - 导航栏点击Bash，执行如下命令，可以Ctrl+V粘贴
```bash
mkdir /home/site/wwwroot/bitwarden
wget -P /home/site/wwwroot/bitwarden/ https://raw.githubusercontent.com/hjh142857/scripts/master/Azure_Bitwarden/bitwarden.sh
```
6. 侧边栏 设置Settings（容器配置Container settings）-> Docker Compose (预览版) -> Docker Hub -> 公开Public -> 连续部署Continuous Deployment（关off） -> 配置Configuration文本框中粘贴yml配置 - 保存Save
    * 参考[Description说明](#Description说明)，按自己需求修改好docker-compose.yml中的环境变量配置，粘贴完yml配置后点击保存，**环境变量配置完成必须删除所有中文注释，否则无法保存**
7. 侧边栏 概述Overview -> 重新启动Restart
8. 如需更新镜像，保证两倍定时备份周期内没有提交密码更新或注册新用户，之后按照步骤7重新启动即可。正常情况Azure会自动拉取最新的镜像，如果发现没有自动拉取最新镜像，可以在YML配置文件中修改image项目，指定引用的镜像版本，如把`image: bitwardenrs/server:alpine`改成`image: bitwardenrs/server:1.15.1-alpine`。建议选择alpine打包的系列以节省免费计划有限的资源配额。

# Tree目录结构
```
[Azure应用服务存储空间/home]/site/wwwroot/bitwarden
    |-----bitwarden.sh         辅助脚本，用于实现Nginx配置生成、定时备份、启动时自动还原等功能
    |-----backup_realtime/     定时备份目录
    |-----backup_daily/        FTP远程备份/日备份的本地目录
```

# ChangeLog更新记录
* 20200719
   * 修复FTP无法同步的BUG
* 20200616
   * 新增YML配置中`DOMAIN`环境变量，以解决Web Admin登录后自动跳转localhost的问题
   * 新增应用升级后更新镜像的相关说明
   * 新增目录结构说明
