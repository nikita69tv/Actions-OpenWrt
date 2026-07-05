#!/bin/bash
# Название файла: diy-part1.sh
# Описание: Подготовка кастомных пакетов в обход ошибки .adb

echo "--- Начинаем загрузку кастомных пакетов напрямую ---"

# Создаем папку для наших кастомных плагинов (чтобы не путались с системными)
mkdir -p package/custom

# 1. Скачиваем Podkop-plus напрямую в локальные пакеты
git clone https://github.com/ushan0v/podkop-plus.git package/custom/podkop

# 2. Скачиваем AmneziaWG напрямую в локальные пакеты
git clone https://github.com/Slava-Shchipunov/awg-openwrt package/custom/amneziawg

# От Helloworld мы отказываемся полностью, поэтому его тут нет.
# В feeds.conf.default мы больше ничего не пишем!

echo "--- Кастомные пакеты успешно загружены локально ---"
