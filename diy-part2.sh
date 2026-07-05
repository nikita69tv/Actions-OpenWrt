#!/bin/bash
# Название файла: diy-part2.sh
# Описание: Только подмена Sing-Box на последнюю Extended версию

echo "--- Начинаем замену Sing-Box на последнюю Extended версию ---"

# 1. Создаем временную папку
mkdir -p temp_singbox

# 2. Получаем ссылку на последний релиз (ищем файл linux-arm64.tar.gz)
LATEST_URL=$(curl -s https://api.github.com/repos/shtorm-7/sing-box-extended/releases/latest | grep "browser_download_url.*linux-arm64.tar.gz" | cut -d '"' -f 4)

if [ -z "$LATEST_URL" ]; then
  echo "Ошибка: Не удалось найти ссылку на последний релиз!"
  exit 1
fi

echo "Скачиваем: $LATEST_URL"

# 3. Скачиваем расширенную версию
wget -O temp_singbox/singbox.tar.gz "$LATEST_URL"

# 4. Распаковываем
tar -xzf temp_singbox/singbox.tar.gz -C temp_singbox

# 5. Создаем структуру для вшивания в образ
mkdir -p files/usr/bin

# 6. Копируем бинарник
find temp_singbox -name "sing-box" -type f -exec cp {} files/usr/bin/sing-box \;

# 7. Делаем исполняемым
chmod +x files/usr/bin/sing-box

# 8. Удаляем временные файлы
rm -rf temp_singbox

echo "--- Последний Extended Sing-Box готов! ---"
