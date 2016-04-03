#!/bin/dash

source /etc/bashrc
source ~/.bashrc

#echo "$IP $URL" >> /etc/hosts

if [ "$DEVELOPMENT" != "false" ]
then
    #hhvm-repo-mode disable
    echo "" > /etc/hhvm/server.ini
else
    echo "Initializing"
    #hhvm-repo-mode enable "$ROOT"
    FILE_LIST=$(mktemp)
    find "/usr/share/php" -type f --name "*.php" > "$FILE_LIST"
    find "$1" -type f --name "*.php" > "$FILE_LIST"
    find "$1" -type f --name "*.hh" > "$FILE_LIST"

    OUT_DIR="/var/run/hhvm"
    hhvm --hphp --target hhbc --output-dir "$OUT_DIR" --input-list "$FILE_LIST" -l3 -v AllVolatile=true    
    echo "hhvm.repo.authoritative = true" > /etc/hhvm/server.ini
fi
echo "include_path=.:$ROOT/include:/usr/share/php" >> /etc/hhvm/server.ini
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