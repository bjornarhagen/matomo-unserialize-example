FROM php:alpine
RUN docker-php-ext-install mysqli pdo_mysql && docker-php-ext-enable mysqli
WORKDIR /app
COPY src .
CMD [ "sh" ]
