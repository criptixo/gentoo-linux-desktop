while true
do
    date=$(date) 
    memory=$(free -m | awk 'NR==2{printf "RAM: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')
    disk=$(df -h | awk '$NF=="/"{printf "/: %d/%dGB (%s)\n", $3,$2,$5}')
    raid=$(df -h | awk '$NF=="/raid"{printf "/raid: %d/%dGB (%s)\n", $3,$2,$5}')
    cpu=$(top -bn1 | grep load | awk '{printf "CPU: %.2f\n", $(NF-2)}')
    uptime=$(uptime -p)
    echo "$uptime | $memory | $disk | $raid | $cpu | $date"
    sleep 1
done 
