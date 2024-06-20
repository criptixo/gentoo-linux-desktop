while true
do
    date=$(date "+%H:%M | %d-%m-%Y")
    memory=$(free -m | awk 'NR==2{printf "RAM: %s/%sMB", $3,$2,$3*100/$2 }')
    cpu=$(top -bn1 | grep load | awk '{printf "CPU: %.2f\n", $(NF-2)}')
    echo "$memory | $cpu | $date |"
    sleep 1
done 
