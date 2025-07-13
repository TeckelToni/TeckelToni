#!/bin/bash
# Raspberry Pi 5 – Optimierungsskript für Alltag, Browser & Multimedia
# Erstellt von Detlef Lübben – inklusive ZRAM, Swappiness, CPU-Tuning und Audio-Priorisierung

clear
echo "🔧 Starte Optimierung für Raspberry Pi 5..."
sleep 1

### 1. CPU-Governor auf 'ondemand'
echo "→ Setze CPU-Governor auf 'ondemand' (dynamischer Takt je nach Last)"
for CPUFREQ in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo ondemand | sudo tee "$CPUFREQ" > /dev/null
done
sleep 1

### 2. Swappiness reduzieren
echo "→ Reduziere Swappiness auf 10 (Swap wird seltener verwendet)"
if ! grep -q "vm.swappiness" /etc/sysctl.conf; then
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf > /dev/null
fi
sudo sysctl -p > /dev/null
sleep 1

### 3. ZRAM aktivieren (nur wenn noch nicht aktiv)
echo "→ ZRAM Swap prüfen und ggf. aktivieren..."
if swapon --show=NAME | grep -q "/dev/zram0"; then
    echo "✓ ZRAM ist bereits aktiv."
else
    echo "→ Aktiviere ZRAM (komprimierter Swap im RAM)"
    sudo modprobe zram

    for i in {1..10}; do
        [ -d /sys/block/zram0 ] && break
        sleep 0.5
    done

    RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    ZRAM_BYTES=$((RAM_KB * 1024 / 2)) # 50% RAM

    echo 1 | sudo tee /sys/block/zram0/reset > /dev/null
    echo $ZRAM_BYTES | sudo tee /sys/block/zram0/disksize > /dev/null
    sudo mkswap /dev/zram0 > /dev/null
    sudo swapon /dev/zram0
    echo "✓ ZRAM erfolgreich aktiviert mit $(($ZRAM_BYTES / 1024 / 1024)) MB"
fi
sleep 1

### 4. PulseAudio priorisieren
echo "→ Audio-Priorisierung (PulseAudio nice_level setzen)"
if command -v pactl &>/dev/null; then
    pactl update-module module-udev-detect nice_level=-5
    echo "✓ Audio nice_level auf -5 gesetzt (höhere Priorität)"
else
    echo "⚠️ PulseAudio nicht erkannt – Audio-Priorisierung übersprungen"
fi
sleep 1

### 5. Logrotate entlasten
echo "→ Setze logrotate auf 'weekly' (weniger Schreibzugriffe)"
sudo sed -i 's/daily/weekly/' /etc/logrotate.conf
sleep 1

### Abschlusshinweis
echo
echo "✅ Optimierung abgeschlossen!"
echo "🔁 Bitte Raspberry Pi neu starten, damit alle Änderungen wirksam werden."
echo "💡 TIPP: YouTube-Last senken mit 'h264ify' oder 'yt-dlp | mpv -'"
