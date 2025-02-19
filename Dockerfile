FROM python:3.9-slim

WORKDIR /babyshop_app

COPY ./babyshop_app ./

RUN python -m pip install -r requirements.txt

EXPOSE 8025

ENTRYPOINT [ "/bin/sh", "-c", "python manage.py makemigrations && python manage.py migrate && python manage.py runserver 0.0.0.0:8025" ]
