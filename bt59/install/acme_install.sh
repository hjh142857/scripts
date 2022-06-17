#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8
acme_path='/root/.acme.sh'
wget -O acme.sh https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh -T 5
bash acme.sh --install --cert-home /www/server/panel/vhost/cert
curl  https://get.acme.sh | sh

if [ ! -f $acme_path/acme.sh ];then
    if [ -f /.acme.sh/acme.sh ];then
    	acme_path='/.acme.sh'
    	ln -sf $acme_path /root/.acme.sh
    else
        public_file=/www/server/panel/install/public.sh
		if [ ! -f $public_file ];then
			wget -O $public_file http://download.bt.cn/install/public.sh -T 5;
		fi
		. $public_file
		download_Url=$NODE_URL
    	wget -O acme.sh $download_Url/install/acme.sh -T 5
		bash acme.sh --install --cert-home /www/server/panel/vhost/cert
    fi
fi

test=`cat $acme_path/account.conf|grep 'vhost'`
if [ "$test" = '' ];then
	echo "CERT_HOME='/www/server/panel/vhost/cert'" >> $acme_path/account.conf
fi
dns_bt=$acme_path/dnsapi/dns_bt.sh
if [ ! -f $dns_bt ];then
	wget -O $dns_bt http://download.bt.cn/install/dns_bt.sh -T 5
fi

rm -f acme.sh