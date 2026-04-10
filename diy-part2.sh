#!/bin/bash
# Название файла: diy-part2.sh
# Описание: Только подмена Sing-Box на Extended версию

echo "--- Подмена Sing-Box на Extended версию ---"
mkdir -p temp_singbox
wget -O temp_singbox/singbox.tar.gz https://github.com/shtorm-7/sing-box-extended/releases/download/v1.13.2-extended-1.6.2/sing-box-1.13.2-extended-1.6.2-linux-arm64.tar.gz
tar -xzf temp_singbox/singbox.tar.gz -C temp_singbox
mkdir -p files/usr/bin
find temp_singbox -name "sing-box" -type f -exec cp {} files/usr/bin/sing-box \;
chmod +x files/usr/bin/sing-box
rm -rf temp_singbox
echo "Extended Sing-Box готов!"
