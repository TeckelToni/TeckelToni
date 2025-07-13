Raspberry Pi 5 Optimizer

Dieses Skript optimiert die Leistung deines Raspberry Pi 5 durch Aktivierung von zram und Anpassung der Swap-Einstellungen. Es sorgt für besseren Umgang mit Arbeitsspeicher und verbessert die Systemperformance besonders bei speicherintensiven Anwendungen.
Inhalt
    Aktiviert zram mit 256 MB
    Setzt Swap-Datei auf 512 MB
    Passt Swappiness und Cache Pressure an für bessere Speicherverwaltung
    Deaktiviert ältere Swap-Partitionen, falls vorhanden
Verwendung
    Lade das Skript rpi5-optimizer.sh herunter oder klone dieses Repository.
Wichtig
    Wenn du einen anderen Benutzernamen als „pi“ benutzt, passe bitte alle Pfade und Befehle im Skript entsprechend an, damit das Skript korrekt funktioniert.
    Gib dem Skript Ausführungsrechte mit:
    chmod +x rpi5-optimizer.sh
Führe das Skript als root oder mit sudo aus:
    sudo ./rpi5-optimizer.sh
    Starte den Raspberry Pi neu, damit alle Änderungen wirksam werden.
Warnung
Dieses Skript ist für den Raspberry Pi 5 optimiert und sollte nicht ohne Anpassungen auf anderen Geräten verwendet werden.
