#! /bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
NAME=nginx
NGINX_BIN=/usr/local/openresty/nginx/sbin/$NAME
CONFIGFILE=/usr/local/openresty/nginx/conf/$NAME.conf
PIDFILE=/usr/local/openresty/nginx/logs/$NAME.pid
ulimit -n 8192
case "$1" in
    start)
        echo -n "Starting $NAME... "
		if [ -f $PIDFILE ];then
			mPID=`cat $PIDFILE`
			isStart=`ps ax | awk '{ print $1 }' | grep -e "^${mPID}$"`
			if [ "$isStart" != '' ];then
				echo "$NAME (pid `pidof $NAME`) already running."
				exit 1
			fi
		fi

        $NGINX_BIN -c $CONFIGFILE

        if [ "$?" != 0 ] ; then
            echo " failed"
            exit 1
        else
            echo " done"
        fi
        ;;

    stop)
        echo -n "Stoping $NAME... "
		if [ -f $PIDFILE ];then
			mPID=`cat $PIDFILE`
			isStart=`ps ax | awk '{ print $1 }' | grep -e "^${mPID}$"`
			if [ "$isStart" = '' ];then
				echo "$NAME is not running."
				exit 1
			fi
		else
			echo "$NAME is not running."
			exit 1
        fi
        $NGINX_BIN -s stop

        if [ "$?" != 0 ] ; then
            echo " failed. Use force-quit"
            exit 1
        else
            echo " done"
        fi
        ;;

    status)
		if [ -f $PIDFILE ];then
			mPID=`cat $PIDFILE`
			isStart=`ps ax | awk '{ print $1 }' | grep -e "^${mPID}$"`
			if [ "$isStart" != '' ];then
				echo "$NAME (pid `pidof $NAME`) already running."
				exit 1
			else
				echo "$NAME is stopped"
				exit 0
			fi
		else
			echo "$NAME is stopped"
			exit 0
        fi
        ;;
    restart)
        $0 stop
        sleep 1
        $0 start
        ;;

    reload)
        echo -n "Reload service $NAME... "
		if [ -f $PIDFILE ];then
			mPID=`cat $PIDFILE`
			isStart=`ps ax | awk '{ print $1 }' | grep -e "^${mPID}$"`
			if [ "$isStart" != '' ];then
				$NGINX_BIN -s reload
				echo " done"
			else
				echo "$NAME is not running, can't reload."
				exit 1
			fi
		else
			echo "$NAME is not running, can't reload."
			exit 1
		fi
        ;;

    configtest)
        echo -n "Test $NAME configure files... "
        $NGINX_BIN -t
        ;;

    *)
        echo "Usage: $0 {start|stop|restart|reload|status|configtest}"
        exit 1
        ;;
esac
