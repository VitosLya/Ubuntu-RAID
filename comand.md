# ОТЧЕТ: Команды для починки RAID и создания разделов

## Команды которые я выполнял:

### 1. Создание RAID 5
```bash
sudo mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sdb /dev/sdc

# "Ломаем" диск
sudo mdadm /dev/md0 --fail /dev/sde

# Удаляем "сломанный" диск
sudo mdadm /dev/md0 --remove /dev/sde

# Добавляем диск обратно (чиним RAID)
sudo mdadm /dev/md0 --add /dev/sde

#Создание GPT таблицы
sudo parted -s /dev/md0 mklabel gpt

#Создание 5 разделов
sudo parted /dev/md0 mkpart primary ext4 0% 20%
sudo parted /dev/md0 mkpart primary ext4 20% 40%
sudo parted /dev/md0 mkpart primary ext4 40% 60%
sudo parted /dev/md0 mkpart primary ext4 60% 80%
sudo parted /dev/md0 mkpart primary ext4 80% 100%

#Форматирование разделов
for i in {1..5}; do sudo mkfs.ext4 /dev/md0p$i; done

#Монтирование разделов
sudo mkdir -p /raid/part{1,2,3,4,5}

for i in {1..5}; do sudo mount /dev/md0p$i /raid/part$i; done
