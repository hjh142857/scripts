# 自建企业微信推送服务
支持文字推送，卡片推送，和markdown推送（markdown仅支持在企业微信客户端内使用，普通微信仅支持文字和卡片推送）

## Ⅰ 使用方法

1. 创建一个PHP文件，复制下方代码进去保存，上传至服务器
2. 注册一个企业微信，很简单，参考大佬教程 `https://github.com/kaixin1995/InformationPush`，然后开通微信插件方便直接在微信查看消息
3. 发送消息
	* 普通文字：`http://域名/index.php?msg=测试提交`
	* 卡片消息：`http://域名/index.php?type=textcard&msg=测试提交`
		* 支持自定义卡片URL和btntxt，`http://域名/index.php?type=textcard&msg=测试提交&url=https://www.hostloc.com&btntxt=更多`
	* markdown：`http://域名/index.php?type=markdown&msg=markdown内容`，需urlencode后提交

## Ⅱ 来源
> [通过企业微信发送提醒消息 支持markdown - Hostloc论坛](https://hostloc.com/thread-671986-1-1.html)    
> [kaixin1995/InformationPush - Github](https://github.com/kaixin1995/InformationPush)
