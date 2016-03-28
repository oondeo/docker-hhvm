#!/bin/dash

if [ "$DEVELOPMENT" != "false" ]
then
    hhvm-repo-mode disable
    echo "" > /etc/hhvm/server.ini
else
    echo "Initializing"
    hhvm-repo-mode enable "$ROOT"
    echo "hhvm.repo.authoritative = true" > /etc/hhvm/server.ini
fi

sleep 2
kill $(cat /var/run/hhvm/pid)

echo "Starting server"
if [ "$PORT" != "9000" ]
then
    hhvm -m server -d hhvm.server.type=proxygen -d hhvm.server.source_root="$ROOT" -d hhvm.server.port=$PORT -p $PORT 
else
    hhvm -m server -d hhvm.server.type=fastcgi -d hhvm.server.port=9000 
fi