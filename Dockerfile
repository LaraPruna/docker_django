FROM python:3
WORKDIR /usr/src/app
RUN pip install django mysqlclient
ADD django_tutorial /usr/src/app
ADD script.sh /opt
RUN pip install -r /usr/src/app/requirements.txt && chmod +x /opt/script.sh
ENV ALLOWED_HOST=*
ENV DJANGO_DATABASE_NAME=polls
CMD ["/opt/script.sh"]
