#Описание

Репозиторий для автоматической сборки кластера ADH (arenadata hadoop) по [документации](https://docs.arenadata.io/adh/install/index.html)
Первоначальная настройка с помощью [ADCM API](https://docs.arenadata.io/adcm/sdk/api/api.html):
1. Установку docker, скачивание образа и запуск adcm
1. Скачивание и установку бандлов
1. Создание кластеров по установленным бандлам
1. Создание хостпровайдеров
1. Добавление хостов

# Требования

Centos 7 на всех нодах. Centos 8 упадет с ошибкой докера -- там ставится podman вместо него
Юзер с правами sudo и возможностью подключаться по ключу на всех нодах
sudo команды не должны требовать пароль
На неймноде открыть порт 8000 (adcm), 8080 (yarn)
На ноде для zeppelin открыть 8080


# Запуск
1. Скопировать проект на неймноду
1. ./conf/nodes_list -- список ip всех нод, начиная с главной 
1. ./conf/env.sh:
    * SETUP_ARENA_USERNAME  - имя юзера на нодах с root правами
    * SETUP_ARENA_KEYFILE=./ssh/id_rsa  - приватный ключ юзера SETUP_ARENA_USERNAME
    * SETUP_ARENA_ADCM_ADMIN_PASSWORD=lkadsjw91wds  - пароль от admin к сервису adcm
1. Поместить private ключ юзера SETUP_ARENA_USERNAME в ./ssh/id_rsa
1. sudo chmod -R 777 ./
1. sudo ./setup_cluster.sh

# Сразу после установки
1. Сменить пароль юзера admin в adcm
1. 