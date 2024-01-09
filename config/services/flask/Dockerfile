FROM python:3.6
WORKDIR /var/www/app/flask

COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt

WORKDIR /var/www/app/flask

EXPOSE 5000
CMD [ "uwsgi", "--ini", "uwsgi.ini" ]
