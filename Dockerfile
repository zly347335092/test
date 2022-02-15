FROM nginx:latest
RUN mkdir /data
COPY ./config/* /etc/nginx/conf.d/
CMD ["nginx","-g","daemon off;"]
