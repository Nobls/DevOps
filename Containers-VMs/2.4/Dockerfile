# Используем базовый образ Ubuntu 20.04
FROM ubuntu:20.04

# Обновляем систему и устанавливаем необходимые компоненты
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y nodejs
RUN apt-get install -y npm

# Установка Node.js и npm
RUN npm install -g n
RUN n stable
RUN apt-get purge -y nodejs npm
RUN apt-get autoremove -y
RUN npm install -g npm@latest

# Создаем директорию в контейнере для приложения
WORKDIR /app

# Копируем файлы вашего веб-приложения в контейнер
COPY . .

# Устанавливаем зависимости
RUN npm install

# Указываем команду для запуска Express.js приложения
CMD ["node", "app.js"]