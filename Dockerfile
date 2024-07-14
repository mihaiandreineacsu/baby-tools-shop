FROM rhazdon/python-pillow

WORKDIR /app

COPY ./babyshop_app $WORKDIR

RUN python -m pip install -r requirements.txt && \
    python manage.py makemigrations && \
    python manage.py migrate

EXPOSE 8025

ENTRYPOINT [ "/bin/sh", "-c", "python manage.py runserver 0.0.0.0:8025" ]