"СКРИПТ СОЗДАНИЯ RAID"

# Создаем RAID 1
mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sdb /dev/sdc

# Создаем GPT таблицу
parted -s /dev/md0 mklabel gpt

# Создаем 5 разделов
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%

# Форматируем разделы
for i in {1..5}; do sudo mkfs.ext4 /dev/md0p$i; done

# Монтируем разделы
mkdir -p /raid/part{1,2,3,4,5}
for i in {1..5}; do mount /dev/md0p$i /raid/part$i; done

"RAID создан"
