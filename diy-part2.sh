#!/bin/bash
# Название файла: diy-part2.sh
# Описание: Скрипт для замены Sing-Box на Extended версию

echo "--- Начинаем подмену Sing-Box на Extended версию ---"

# 1. Создаем временную папку
mkdir -p temp_singbox

# 2. Скачиваем расширенную версию (arm64 подходит и для AX3200, и для AX3000T)
wget -O temp_singbox/singbox.tar.gz https://github.com/shtorm-7/sing-box-extended/releases/download/v1.13.2-extended-1.6.2/sing-box-1.13.2-extended-1.6.2-linux-arm64.tar.gz

# 3. Распаковываем
tar -xzf temp_singbox/singbox.tar.gz -C temp_singbox

# 4. Создаем структуру для вшивания в образ
mkdir -p files/usr/bin

# 5. Копируем бинарник (ищем его внутри распакованного мусора)
find temp_singbox -name "sing-box" -type f -exec cp {} files/usr/bin/sing-box \;

# 6. Делаем исполняемым
chmod +x files/usr/bin/sing-box

# 7. Удаляем временные файлы
rm -rf temp_singbox

echo "Extended Sing-Box успешно подложен в файлы сборки!"
