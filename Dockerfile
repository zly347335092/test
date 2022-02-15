FROM nginx:latest
RUN mkdir /data
COPY config/test.conf /etc/nginx/conf.d/
