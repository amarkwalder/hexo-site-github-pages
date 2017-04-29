FROM nginx:alpine
MAINTAINER André Markwalder <andre.markwalder@gmail.com>

COPY public/ /usr/share/nginx/html/
