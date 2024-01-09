FROM python:3.6
WORKDIR /var/www/app/flask

COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt

WORKDIR /var/www/app/flask

EXPOSE 5000
CMD [ "uwsgi", "--ini", "uwsgi.ini" ]

#CMD ["uwsgi", "--http", "0.0.0.0:80", "--wsgi-file", "/app/start.py", \
#    "--callable", "app", "--stats", "0.0.0.0:81"]
