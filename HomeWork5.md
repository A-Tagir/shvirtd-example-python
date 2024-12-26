#
Задача 1.
#
* Создаем файл Dockerfile.python
  
  [github] (https://github.com/A-Tagir/shvirtd-example-python/blob/main/Dockerfile.python)

* создаем файл .dockerignore
  
  [github] (https://github.com/A-Tagir/shvirtd-example-python/blob/main/.dockerignore)

* Проверяем как собирается образ
  docker build -f Dockerfile.python . -t atagir/mainpython:1.0.0
  ![образ собрался](https://github.com/A-Tagir/shvirtd-example-python/blob/main/homework5_build_mainpython.jpg)

#
Задача 2.
#
* В консоли яндекс облака создал новый каталог "netology-homework"
* создал профиль (иначе реестр создается в каталоге по умолчанию)
  yc config profile create netology-homework
* сделал yc container registry configure-docker
        yc init
  где выбрал профиль netology-homework и авторизовал его.
* Создал в yandex cloud container registry с именем "test"
  yc container registry create --name test
* далее присвоил образу тег с ID реестра
  docker tag mainpython:1.0.0 cr.yandex/crpjb76iojk2s0j0hb2t/mainpython:1.0.0
* И залил образ в реестр
   docker push cr.yandex/crpjb76iojk2s0j0hb2t/mainpython:1.0.0
* просканировал на уязвимости
  ![89 различных уязвимостей](https://github.com/A-Tagir/shvirtd-example-python/blob/main/homework5_ycloud_scanner.jpg)

#
Задача 3.
#
* Создал файл compose.yaml с include и сервисами web и db.
  переменные окружения передаются в сервис web файлом web.env:
  DB_NAME="virtd"
  DB_HOST="db"
  DB_USER="app"
  а в сервис db файлом .env который уже существовал в репе.
  Файл web.env загружен в github поскольку уже был.
  web.env не содердит пароль и его загружаем в github
  пароль передаем в сервис web через 
  export DB_PASSWORD='password'
* Проверяю сборку файла compose.yaml
  ![сборка проходит!](https://github.com/A-Tagir/shvirtd-example-python/blob/main/homework5_compose_test.jpg)
  В данном случае Docker Compose version v2.32.1 предлагает убрать упоминание версии, в своем compose.yaml я так и сделал, однак по правилам задания изменять файлы уже существующие в форке - запрещено. Поэтому игнорирую WARN.
* Запускаем командой export DB_PASSWORD='password' && docker compose up -d
  проверяем, что не падает docker compose ps и вызываем curl -L http://127.0.0.1:8090
  ![все работает!](https://github.com/A-Tagir/shvirtd-example-python/blob/main/homework5_compose_up.jpg)
  видим, что main.py отвечает 
  TIME: 2024-12-26 10:12:19, IP: 127.0.0.1
* Заходим в db 
  docker exec -ti shvirtd-example-python-db-1  mysql -uroot -pXXXXXXX
  и выполняем все тестовые команды задания:
  ![mysql select!](https://github.com/A-Tagir/shvirtd-example-python/blob/main/homework5_compose_mysql.jpg)
* Останавливаем проект:
   docker compose down
#
Задача 4
#
* Запустил ВМ в облаке яндекс 2Гб, CPU 5% и подключился по SSH:
 System information as of Thu Dec 26 10:48:57 AM UTC 2024

  System load:  0.3               Processes:             138
  Usage of /:   30.0% of 9.76GB   Users logged in:       0
  Memory usage: 10%               IPv4 address for eth0: 10.128.0.8
  Swap usage:   0% 
* Установил docker
  curl -fsSL https://get.docker.com -o get-docker.sh
  get-docker.sh
* написал bash для копирования и запуска:
[github](https://github.com/A-Tagir/shvirtd-example-python/blob/main/runshvirt.sh)
!#/bin/bash
PASS=$1
git clone https://github.com/A-Tagir/shvirtd-example-python /opt/virtd/
cd /opt/virtd/
export DB_PASSWORD=$PASS && /usr/bin/docker compose up -d  
Запускаем его следующим образом:
./runshvirt.sh пароль_дб
![up_ok](https://github.com/A-Tagir/shvirtd-example-python/blob/main/homework5_compose_ycloud.jpg)
проверяем
http://89.169.134.53:8090/
TIME: 2024-12-26 12:34:38, IP: 89.179.XXX.XXX
* Запускаем Check_http
  ![http_ok](https://github.com/A-Tagir/shvirtd-example-python/blob/main/homework5_compose_ycloud_http_test.jpg)
видим что работает, но падает под нагрузкой. Возможно 5% CPU причина.
* подключаемся к бд и делаем запрос:
  ![select_cloud_ok](https://github.com/A-Tagir/shvirtd-example-python/blob/main/homework5_compose_ycloud_db_select.jpg)
* Останавливаем проект.
#
Задание 6
#
* установил dive
  sudo apt install ./dive.deb
* анализирую образ
![bin_finded](https://github.com/A-Tagir/shvirtd-example-python/blob/main/homework5_compose_dive.jpg)
запоминаем sha256
echo 'a2291ae31714cd13ae948f4cf01a5599ea46e49e3991c0a056ba3719c8d84e21'
Сохраняем образ
docker save hashicorp/terraform -o image.tar
Распаковываем
 tar -xf image.tar
Находим 
 ls blobs/sha256 | grep 'a2291ae31714cd13ae948f4cf01a5599ea46e49e3991c0a056ba3719c8d84e21'
a2291ae31714cd13ae948f4cf01a5599ea46e49e3991c0a056ba3719c8d84e21
распаковываем
tar -xf ./blobs/sha256/a2291ae31714cd13ae948f4cf01a5599ea46e49e3991c0a056ba3719c8d84e21
и получаем
![Got bin!](https://github.com/A-Tagir/shvirtd-example-python/blob/main/homework5_compose_dive_get_bin.jpg)
#
Задание 6.1
#
* Инициализируем контейнер
docker run -it hashicorp/terraform init
* копируем файл
  docker cp 4756605adbe7:/bin/terraform /home/tiger/dive/
Successfully copied 90.2MB to /home/tiger/dive
![get bin by cp](https://github.com/A-Tagir/shvirtd-example-python/blob/main/homework5_compose_get_bin_cp.jpg)
#


  