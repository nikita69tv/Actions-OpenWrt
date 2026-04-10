#!/bin/bash
#
# Название файла: diy-part2.sh
# Описание: Скрипт для тонкой настройки пакетов после обновления фидов
#

# --- 1. СЕТЕВЫЕ НАСТРОЙКИ ---
# Изменение дефолтного IP роутера (раскомментируй и поменяй, если нужно)
# sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# --- 2. ЗАМЕНА СТАНДАРТНЫХ КОМПОНЕНТОВ ---
# Удаляем базовый dnsmasq и ставим полную версию (нужна для многих VPN решений)
echo "CONFIG_PACKAGE_dnsmasq=n" >> .config
echo "CONFIG_PACKAGE_dnsmasq-full=y" >> .config

# Удаляем базовый wpad и ставим версию с поддержкой OpenSSL (для продвинутого Wi-Fi)
echo "CONFIG_PACKAGE_wpad-basic-mbedtls=n" >> .config
echo "CONFIG_PACKAGE_wpad-openssl=y" >> .config

# --- 3. ИНТЕРФЕЙС И ЛОКАЛИЗАЦИЯ ---
# Базовая LuCI, русский язык и поддержка SSL для веб-морды
for pkg in luci luci-ssl luci-i18n-base-ru luci-i18n-firewall-ru luci-i18n-package-manager-ru; do
    echo "CONFIG_PACKAGE_$pkg=y" >> .config
done

# --- 4. СИСТЕМНЫЕ УТИЛИТЫ ---
# Набор "джентльмена": файловые менеджеры, редакторы и системные мониторы
for pkg in nano mc btop htop curl jq ca-bundle openssh-sftp-server; do
    echo "CONFIG_PACKAGE_$pkg=y" >> .config
done

# --- 5. МОНИТОРИНГ И СТАТИСТИКА ---
# Статистика в реальном времени (Netdata) и графики (Statistics/Collectd)
echo "CONFIG_PACKAGE_netdata=y" >> .config

for pkg in luci-app-statistics luci-i18n-statistics-ru collectd; do
    echo "CONFIG_PACKAGE_$pkg=y" >> .config
done

# Модули для сбора данных collectd (процессор, память, сеть, wifi)
for mod in conntrack cpu cpufreq entropy interface iwinfo load memory network ping rrdtool thermal uptime; do
    echo "CONFIG_PACKAGE_collectd-mod-$mod=y" >> .config
done

# Экспортеры для Prometheus (если используешь внешнюю панель мониторинга)
for prom in lua lua-nat_traffic lua-netstat lua-openwrt lua-wifi; do
    echo "CONFIG_PACKAGE_prometheus-node-exporter-$prom=y" >> .config
done

# --- 6. СЕТЕВЫЕ СЕРВИСЫ (SQM, UPNP, WATCHCAT) ---
# SQM (борьба с лагами), UPnP и автоматический ребутер (Watchcat)
for pkg in luci-app-sqm luci-i18n-sqm-ru sqm-scripts tc-tiny \
luci-app-upnp luci-i18n-upnp-ru \
luci-app-watchcat luci-i18n-watchcat-ru watchcat \
luci-app-nlbwmon luci-i18n-nlbwmon-ru nlbwmon; do
    echo "CONFIG_PACKAGE_$pkg=y" >> .config
done

# --- 7. VPN И ОБХОД БЛОКИРОВОК ---
# Sing-box (ядро для многих протоколов)
echo "CONFIG_PACKAGE_sing-box=y" >> .config

# AmneziaWG (протокол и интерфейс)
for pkg in kmod-amneziawg amneziawg-tools luci-proto-amneziawg luci-i18n-amneziawg-ru; do
    echo "CONFIG_PACKAGE_$pkg=y" >> .config
done

# Podkop (точечный обход блокировок)
for pkg in podkop luci-app-podkop luci-i18n-podkop-ru; do
    echo "CONFIG_PACKAGE_$pkg=y" >> .config
done

# --- 8. ПОДМЕНА ЯДРА SING-BOX НА EXTENDED ВЕРСИЮ ---
# 1. Создаем временную папку для работы
mkdir -p temp_singbox

# 2. Скачиваем расширенную версию (arm64)
wget -O temp_singbox/singbox.tar.gz https://github.com/shtorm-7/sing-box-extended/releases/download/v1.13.2-extended-1.6.2/sing-box-1.13.2-extended-1.6.2-linux-arm64.tar.gz

# 3. Распаковываем архив
tar -xzf temp_singbox/singbox.tar.gz -C temp_singbox

# 4. Создаем структуру папок 'files'. 
# В GitHub Actions корень сборки обычно и есть текущая папка.
mkdir -p files/usr/bin

# 5. Копируем расширенный файл sing-box в нашу структуру
find temp_singbox -name "sing-box" -type f -exec cp {} files/usr/bin/sing-box \;

# 6. Делаем файл исполняемым (критически важно для работы сервиса)
chmod +x files/usr/bin/sing-box

# 7. Удаляем временный мусор
rm -rf temp_singbox

echo "Extended Sing-Box успешно подложен в папку files!"
