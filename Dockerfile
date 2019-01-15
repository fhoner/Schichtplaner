FROM keopx/apache-php:7.3

ENV DB_PREFIX=planer_

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - \
        && apt-get install -y nodejs
RUN npm install -g grunt \
        && npm install -g grunt-cli

RUN git clone https://github.com/fhoner/Schichtplaner.git
RUN cd Schichtplaner \
        && git checkout docker \
        && npm install \
        && grunt \
        && composer install \
        && mv config_docker.php config.php 
RUN cp -r Schichtplaner/* /var/www/html/ \
        && chown www-data:www-data /var/www/html -R \
        && rm index.html
