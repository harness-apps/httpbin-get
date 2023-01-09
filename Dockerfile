FROM nginx

WORKDIR public

COPY public /usr/share/nginx/html

