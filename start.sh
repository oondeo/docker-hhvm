#!/bin/sh

if [ "$DEVELOPMENT" != "false" ]
then
    hhvm-repo-mode disable
else
    echo "Initializing"
    hhvm-repo-mode enable "$ROOT"
fi

echo "Starting server"
if [ "$PORT" != "9000" ]
then
    hhvm -m server -d hhvm.server.type=proxygen -d hhvm.server.source_root="$ROOT" -d hhvm.server.port=$PORT -p $PORT -u www-data
else
    hhvm -m server -d hhvm.server.type=fastcgi -d hhvm.server.port=9000 -u www-data
fi