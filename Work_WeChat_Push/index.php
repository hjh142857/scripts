<?php
if(!isset($_REQUEST['msg'])) { exit; }

$corpid = ''; // 填写企业ID
$agentid = ''; // 填写应用ID
$corpsecret = ''; // 填写应用Secret

$access_token = json_decode(icurl("https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$corpid&corpsecret=$corpsecret"),true)["access_token"];
$url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=".$access_token;

$msg = urldecode($_REQUEST['msg']);
$type = $_REQUEST['type'];
switch ($type) {
    // 文本卡片消息
    case 'textcard':
        $data = array(
            'touser' => '@all',
            'toparty' => '@all',
            'totag' => '@all',
            'msgtype' => 'textcard',
            'agentid' => $agentid,
            'textcard' => array(
                'title' => $_REQUEST['title'] ?? '新提醒',
                'description' => $msg,
                'url' => $_REQUEST['url'] ?? 'https://www.hostloc.com',
                'btntxt' => $_REQUEST['btntxt'] ?? '详情',
            ),
            'enable_id_trans' => 0,
            'enable_duplicate_check' => 0,
            'duplicate_check_interval' => 1800,
        );
        break;

    // markdown消息，仅企业微信内可以查看
    case 'markdown':
        $data = array(
            'touser' => '@all',
            'toparty' => '@all',
            'totag' => '@all',
            'msgtype' => 'markdown',
            'agentid' => $agentid,
            'markdown' => array(
                'content' => $msg,
            ),
            'enable_duplicate_check' => 0,
            'duplicate_check_interval' => 1800,
        );
        break;

    // 文本消息
    default:
        $data = array(
            'touser' => '@all',
            'toparty' => '@all',
            'totag' => '@all',
            'msgtype' => 'text',
            'agentid' => $agentid,
            'text' => array(
                'content' => $msg,
            ),
            'safe' => 0,
            'enable_id_trans' => 0,
            'enable_duplicate_check' => 0,
            'duplicate_check_interval' => 1800,
        );
        break;
}

$res = json_decode(icurl($url,json_encode($data)));

if ( $res->errcode == 0 ) { echo "Success"; } else { echo "Error：".$res->errmsg; }

function icurl($url, $data = null)
{
    $curl = curl_init();
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE);
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, FALSE);
    if (!empty($data)) {
        curl_setopt($curl, CURLOPT_POST, 1);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
    }
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    $res = curl_exec($curl);
    curl_close($curl);
    return $res;
}
