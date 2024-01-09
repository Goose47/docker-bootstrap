FROM tiangolo/uwsgi-nginx-flask:python3.8-alpine
RUN apk --update add bash nano
ENV STATIC_URL /static
ENV STATIC_PATH /var/www/app/flask/app/static

WORKDIR /var/www/app/flask

COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 5000
CMD [ "uwsgi", "--ini", "uwsgi.ini" ]
