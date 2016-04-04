#!/bin/dash

OUT_DIR="/var/run/hhvm"

if [ -f /etc/bashrc ]
then 
. /etc/bashrc
fi
if [ -f ~/.bashrc ]
then
. ~/.bashrc
fi
#echo "$IP $URL" >> /etc/hosts
cd $ROOT
sed -i '/include_path/d' /etc/hhvm/php.ini
echo "include_path=\".:$ROOT/include:/usr/share/php\"" >> /etc/hhvm/php.ini

if [ "$DEVELOPMENT" = "true" ] || [ "$COMPILE" = "false" ]
then
    #hhvm-repo-mode disable
    sed -i '/hhvm.repo.central.path/d' /etc/hhvm/php.ini
    sed -i '/hhvm.repo.authoritative/d' /etc/hhvm/php.ini
else
    echo "Initializing"
    echo "hhvm.repo.central.path = $OUT_DIR/hhvm.hhbc" >> /etc/hhvm/php.ini
    echo "hhvm.repo.authoritative = true" >> /etc/hhvm/php.ini
    #hhvm-repo-mode enable "$ROOT"
    FILE_LIST=$(mktemp)
    grep -r "^<?php" "/usr/share/php" | cut -f1 -d":" > "$FILE_LIST"
    #find "$ROOT" -type f -name "*.php" >> "$FILE_LIST"
    #find "$ROOT" -type f -name "*.hh" >> "$FILE_LIST"
    #find "$ROOT" -type f -name "*.inc" >> "$FILE_LIST"
    grep -r "^<?php" "$ROOT" | cut -f1 -d":" >> "$FILE_LIST"
    grep -r "^<?hh" "$ROOT" | cut -f1 -d":" >> "$FILE_LIST"
    #find "$ROOT" -type f  >> "$FILE_LIST"



    hhvm --hphp --target hhbc --output-dir "$OUT_DIR" --input-list "$FILE_LIST" $COMPILE_OPTS    
    #echo "hhvm.repo.authoritative = true" >> /etc/hhvm/php.ini
fi


sleep 2
#kill $(cat /var/run/hhvm/pid)

echo "Starting server"
if [ "$PORT" != "9000" ]
then
    hhvm -m server -d hhvm.server.type=proxygen -d hhvm.server.source_root="$ROOT" -d hhvm.server.port=$PORT -p $PORT 
else
    hhvm -m server -d hhvm.server.type=fastcgi -d hhvm.server.port=9000 
fi