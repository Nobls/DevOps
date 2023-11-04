# Создание многоконтейнерного приложения с использованием Docker и Docker Compose

### Создание многоконтейнерного приложения

Веб-приложение: 

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <div>
        Hello Docker Compose
    </div>
</body>
</html>
```
Dockerfile для веб-приложения:

```
FROM nginx:latest
COPY ./app /usr/share/nginx/html
```

Dockerfile для базы данных (db/Dockerfile) не требуется, так как будет использоваться готовый образ PostgreSQL.

### Настройка Docker Compose

Был создан файл **docker-compose.yml**

```
version: '3.7'
services:
  web:
    build:
      context: ./web
    ports:
      - "8080:80"
    volumes:
      - ./app:/usr/share/nginx/html
  db:
    image: postgres:latest
    environment:
      POSTGRES_DB: db
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
```

version: '3.7': Эта строка указывает на версию схемы конфигурации Docker Compose. 

services: Этот блок определяет сервисы (контейнеры). В вашем случае, есть два сервиса: "web" и "db".

**web**:

*  build: Здесь указывается, что контейнер "web" должен быть создан на основе Dockerfile, который находится в директории ./web. Это позволяет собрать контейнер на основе настроек и инструкций в этом Dockerfile.
*  ports: Эта строка прокидывает порт 8080 контейнера в порт 80 хостовой машины, что позволит вам обращаться к веб-приложению через http://localhost.
*  volumes: Эта строка монтирует локальную директорию ./app внутрь контейнера в директорию /usr/share/nginx/html. Это позволяет веб-приложению обслуживать статические файлы из этой директории.

**db**:

* image: Эта строка указывает, что для сервиса "db" следует использовать готовый образ PostgreSQL с тегом "latest".
* environment: Здесь задаются переменные среды, необходимые для настройки базы данных PostgreSQL. В данном случае, устанавливаются имя базы данных (POSTGRES_DB), имя пользователя (POSTGRES_USER) и пароль (POSTGRES_PASSWORD).