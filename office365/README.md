# Office365.ps1
## 查看 Office365 全局信息, 许可证信息等.(无需管理员权限)
```
Office365.ps1 -u <用户名> -p <密码> -l <许可证全名> -cn
        -u <用户名>
        // (可选) 用户登录的邮箱.
        -p <密码>
        // (可选) 用户登录的密码.
        -l <许可证全名>
        // (可选) 选择需要查看的许可证
        -cn 
        // *如果托管于世纪互联,则需要使用此参数.
```

## 示例
```
# 国际版
./Office365.ps1 -u moeclub@github.onmicrosoft.com -p PASSWORD

# 中国版(世纪互联)
./Office365.ps1 -u moeclub@github.partner.onmschina.cn -p PASSWORD -cn
```

## 使用说明
```
Login: admin@piaoyuncc.onmicrosoft.com
User Role: User    # 此用户在组织内的角色. User: 普通用户; Company Administrator: 全局管理员
Admin User: [Disable]admin@piaoyuncc.onmicrosoft.com;    # 全局管理员状态列表. [Disable]表示该全局管理员目前不可以登录. [Enable]表示该全局管理员目前可以登录. [Null]表示该组织目前无全局管理员.
Office365 SKU: DEVELOPERPACK; STANDARDWOFFPACK_STUDENT; STANDARDWOFFPACK_FACULTY; STANDARDWOFFPACK_IW_FACULTY; STANDARDWOFFPACK_IW_STUDENT;   # 组织内可用的SKU列表

Query Office365 SKU: STANDARDWOFFPACK_IW_STUDENT    # 输入要查询的SKU名称

SkuName: STANDARDWOFFPACK_IW_STUDENT    # 显示SKU名称
ActiveUnits: 1000000    # 显示SKU可用许可证数量
ConsumedUnits: 1    # 显示SKU已分配许可证数量
TotalUnits: 1000000    # 显示SKU总共许可证数量
SubscriptionStatus: Enabled    # 显示许可证状态. 如果是Enabled状态,则订阅正常. 如果含有[Trial]标记,则表示为试用类型订阅.
SubscriptionDate: 10/17/2015    # 订阅创建日期. 如果调整过许可证数量,则显示为最近调整的日期.
SubscriptionId: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx    # 订阅唯一ID.
```

# Office365_OneDrive.ps1
## 设置 OneDrive 预设网盘容量和已存在用户的网盘容量.(需要全局管理员账户)
```
Office365_OneDrive.ps1 -u <用户名> -p <密码> -q <容量> -cn
        -u <用户名>
        // (可选) 用户登录的邮箱.
        -p <密码>
        // (可选) 用户登录的密码.
        -q <容量>
        // (可选) 设置容量大小,默认:5,单位TB.
        -cn 
        // *如果托管于世纪互联,则需要使用此参数.
```

## 示例
```
# 国际版
./Office365_OneDrive.ps1 -u moeclub@github.onmicrosoft.com -p PASSWORD -q 5

# 中国版(世纪互联)
./Office365_OneDrive.ps1 -u moeclub@github.partner.onmschina.cn -p PASSWORD -q 5 -cn
```

# 报错处理
```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
```

# 新手教程 [点此查看](https://github.com/MoeClub/Office365/blob/master/New.MD)

# 许可证名称-产品名称-SKU [对照表](https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/licensing-service-plan-reference)
