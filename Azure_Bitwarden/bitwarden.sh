#!/usr/bin/env sh
# vim:sw=4:ts=4:et

set -e

## nginx启动部分
if [ "$1" = "nginx" ]; then

    ## 生成vhost配置
    mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
    echo '
upstream  rocket  {
    server   bitwarden:80;
}
upstream  ws  {
    server   bitwarden:3012;
}
server {
    listen       80;
    listen  [::]:80;

    location /notifications/hub/negotiate {
        proxy_pass http://rocket;
    }
    location /notifications/hub {
        proxy_pass http://ws;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
    location /
    {
        proxy_pass http://rocket;
        proxy_set_header  Host              $host;
        proxy_set_header  X-Real-IP         $remote_addr;
        proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header  X-Forwarded-Proto $scheme;
    }
}' > /etc/nginx/conf.d/default.conf
    /docker-entrypoint.sh

## bitwarden启动部分
elif [ "$1" = "/bitwarden_rs" ]; then

    ## 新建备份文件夹
    if [ ! -d "/home/backup_daily" ]; then
        mkdir /home/backup_daily
    fi
    if [ ! -d "/home/backup_realtime" ]; then
        mkdir /home/backup_realtime
    fi

    ## 检查是否有备份，有则还原
    echo "Finding Bitwarden backup..."
    if [ -n "$(find /home/backup_realtime -maxdepth 1 -name 'bitwarden_backup_realtime_*.tar.gz')" ]; then
        echo "Found the latest realtime backup, restoring now..."
        tar zxf /home/backup_realtime/`ls -l /home/backup_realtime | grep bitwarden_backup_realtime_ | tail -n1 | awk '{print $9}'` -C /
        echo "Restored `ls -l /home/backup_realtime | grep bitwarden_backup_realtime_ | tail -n1 | awk '{print $9}'` Successful"
    elif [ -n "$(find /home/backup_daily -maxdepth 1 -name 'bitwarden_backup_daily_*.tar.gz')" ]; then
        echo "Found the latest daily backup, restoring now..."
        tar zxf /home/backup_daily/`ls -l /home/backup_daily | grep bitwarden_backup_daily_ | tail -n1 | awk '{print $9}'` -C /
        echo "Restored `ls -l /home/backup_daily | grep bitwarden_backup_daily_ | tail -n1 | awk '{print $9}'` Successful"
    else
        echo "Backup No Found, Initializing Bitwarden..."
    fi

    ## 设置时区为UTC+8
    # apk add --no-cache tzdata
    # cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    # echo "Asia/Shanghai" > /etc/timezone
    # apk del tzdata


    ## 生成bitwarden自动备份脚本并后台执行
    echo '
#!/usr/bin/env sh
# vim:sw=4:ts=4:et

set -e

HOUR=`date "+%-H"`
MIN=`date "+%-M"`
SEC=`date "+%-S"`
realtime_sec=$((10#${REALTIME_BAK_CYCLE}*60-(${MIN}%${REALTIME_BAK_CYCLE})*60-${SEC}))
daily_count=$(((10#86400-((${HOUR}+8)%24)*3600-${MIN}*60-${SEC})/(${REALTIME_BAK_CYCLE}*60)))
sleep $realtime_sec
while [ $REALTIME_BAK_CYCLE -gt 0 ]; do
    TIME=$(date -d @$((`date +%s` +3600*8 )) "+%Y%m%d_%H%M")
    tar -zcvf /home/backup_realtime/bitwarden_backup_realtime_$TIME.tar.gz -C / data
    find /home/backup_realtime/ -mtime +0 -delete
    if [ $daily_count -gt 0 ]; then
        daily_count=$(($daily_count-1))
    else
        mv /home/backup_realtime/bitwarden_backup_realtime_$TIME.tar.gz /home/backup_daily/bitwarden_backup_daily_${TIME:0:8}.tar.gz
        find /home/backup_daily/ -mtime +$((${DAILY_BAK_COUNTS}-1)) -delete
        daily_count=$((1440/$REALTIME_BAK_CYCLE-1))
        if [ -n "$FTP_URL" ]; then
            curl $FTP_URL -u "$FTP_USER:$FTP_PASS" -T "/home/backup_daily/bitwarden_backup_daily_${TIME:0:8}.tar.gz"
            curl $FTP_URL -u "$FTP_USER:$FTP_PASS" -X "DELE bitwarden_backup_daily_$(date -d @$((`date +%s` +3600*8-86400*$DAILY_BAK_COUNTS )) "+%Y%m%d").tar.gz"
        fi
    fi
    HOUR=`date "+%-H"`
    MIN=`date "+%-M"`
    SEC=`date "+%-S"`
    realtime_sec=$((10#${REALTIME_BAK_CYCLE}*60-(${MIN}%${REALTIME_BAK_CYCLE})*60-${SEC}))
    sleep $realtime_sec
done


exec "$@"' > /autobackup.sh
    chmod a+x /autobackup.sh
    /autobackup.sh &
fi

exec "$@"
