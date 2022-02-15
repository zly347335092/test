FROM nginx:latest
RUN mkdir /data
COPY ./config/* /etc/nginx/conf.d/
