#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
# Обновляем фиды
#./scripts/feeds update -a
#./scripts/feeds install -a

# Выбираем пакеты для сборки (эквивалент выбора в menuconfig)
echo "CONFIG_PACKAGE_luci-app-podkop=y" >> .config
echo "CONFIG_PACKAGE_sing-box=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq-full=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq=n" >> .config
# Выбираем пакеты AmneziaWG
echo "CONFIG_PACKAGE_kmod-amneziawg=y" >> .config
echo "CONFIG_PACKAGE_amneziawg-tools=y" >> .config
echo "CONFIG_PACKAGE_luci-proto-amneziawg=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-amneziawg-ru=y" >> .config

# Если хочешь, чтобы Подкоп тоже был сразу в прошивке:
echo "CONFIG_PACKAGE_podkop=y" >> .config
echo "CONFIG_PACKAGE_luci-app-podkop=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-podkop-ru=y" >> .config

# 1. Замена базовых пакетов на расширенные (dnsmasq и wpad)
echo "CONFIG_PACKAGE_dnsmasq=n" >> .config
echo "CONFIG_PACKAGE_dnsmasq-full=y" >> .config
echo "CONFIG_PACKAGE_wpad-basic-mbedtls=n" >> .config
echo "CONFIG_PACKAGE_wpad-openssl=y" >> .config

# 2. Основной софт (Утилиты и системные компоненты)
for pkg in luci luci-i18n-base-ru luci-i18n-firewall-ru luci-i18n-package-manager-ru \
luci-ssl sing-box curl jq ca-bundle nano mc btop htop netdata openssh-sftp-server \
luci-app-sqm luci-i18n-sqm-ru sqm-scripts tc-tiny \
luci-app-upnp luci-i18n-upnp-ru luci-app-watchcat luci-i18n-watchcat-ru watchcat \
luci-app-nlbwmon luci-i18n-nlbwmon-ru nlbwmon; do
    echo "CONFIG_PACKAGE_$pkg=y" >> .config
done

# 3. Мониторинг (Statistics и Prometheus)
for pkg in luci-app-statistics luci-i18n-statistics-ru collectd collectd-mod-conntrack \
collectd-mod-cpu collectd-mod-cpufreq collectd-mod-entropy collectd-mod-interface \
collectd-mod-iwinfo collectd-mod-load collectd-mod-memory collectd-mod-network \
collectd-mod-ping collectd-mod-rrdtool collectd-mod-thermal collectd-mod-uptime \
prometheus-node-exporter-lua prometheus-node-exporter-lua-nat_traffic \
prometheus-node-exporter-lua-netstat prometheus-node-exporter-lua-openwrt \
prometheus-node-exporter-lua-wifi; do
    echo "CONFIG_PACKAGE_$pkg=y" >> .config
done

# 4. AmneziaWG и Podkop
for pkg in podkop luci-app-podkop luci-i18n-podkop-ru \
amneziawg-tools kmod-amneziawg luci-proto-amneziawg luci-i18n-amneziawg-ru; do
    echo "CONFIG_PACKAGE_$pkg=y" >> .config
done
