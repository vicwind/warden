#/bin/bash

sub_cmd=$1; shift
opt=$1; shift

if [[ $WARDEN_WEB_HOME == '' ]];then
  echo "Error: WARDEN_WEB_HOME is not set."
  exit 1
fi

case $sub_cmd in
  unicorn)
    case $opt in
      start)
        echo "Starting..."
        unicorn_rails -D -c $WARDEN_WEB_HOME/config/unicorn_config.rb
        if [ $? == 0 ]; then
          echo "Unicorn app server started."
        else
          echo "Can not start Unicorn."
          echo "Please check log in $WARDEN_WEB_HOME/log/unicorn.stderr.log"
        fi
        ;;

      stop)
        pid_file="$WARDEN_WEB_HOME/log/unicorn.pid"
        if [ -f $pid_file ]; then
          echo "Shuting down Unicorn..."
          kill -QUIT `cat $pid_file`
          sleep 1
          echo "Done"
        else
          echo "PID file not found at $pid_file"
        fi
        ;;
      status)
        echo "Unicorn processes list:"
        ps -eafw | grep unicorn | grep -v grep | grep -v warden_web.sh
        ;;
      *)
        echo "Error: required command start|stop|status"
        exit 1
        ;;
    esac
  ;;

  worker)
    case $opt in
      start|stop|status)
        export WORKER_NUMBER=$1
        export QUEUE=*
        export VERBOSE=1
        current_dir=`pwd`
        cd $WARDEN_WEB_HOME
        cmd="ruby ./script/resque_worker.rb $opt"
        $cmd
        cd $current_dir
        ;;
      *)
        echo "Error: required command start|stop|status"
        exit 1
        ;;
    esac
    ;;

  worker-d)
    case $opt in
      start)
        number_of_worker=$1
        current_dir=`pwd`
        cd $WARDEN_WEB_HOME
        for (( i=1; i<=$number_of_worker; i++ ))
        do
          export BACKGROUND=1
          export VERBOSE=1
          export PIDFILE=$WARDEN_WEB_HOME/log/resque_worker_$i.pid
          export QUEUE=*
          worker_log="$WARDEN_WEB_HOME/log/resque_worker_$1.log"
          cmd="rake environment resque:work >$worker_log 2>&1"
          echo "Starting worker $i ..."
          `$cmd`
        done
        cd $current_dir
        sleep 1
        ps -eafw|grep resque
        echo "Done"
        ;;

      stop)
        pids=`ls $WARDEN_WEB_HOME/log/resque_worker_*.pid`
        for pid_file in $pids
        do
          pid=`cat $pid_file`
          echo "Killing process $pid"
          kill -QUIT $pid
        done
        echo "Done"
    esac
  ;;
  *)
    echo "Usage: warden_web.sh unicorn [ start|stop|status ]"
    echo "       warden_web.sh worker start <number_of_worker>"
    echo "       warden_web.sh worker [ status|stop ]"
  ;;

esac
