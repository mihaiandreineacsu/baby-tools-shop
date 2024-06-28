#!/bin/sh

set -e

python manage.py makemigrations
python manage.py migrate

if [ "$DEV" = "True" ]; then
    echo "Run in development server"
    exec python manage.py runserver 0.0.0.0:8000
else
    echo "Collecting statics"
    python manage.py collectstatic --no-input
    echo "Running Gunicorn for Production"
    exec /py/bin/gunicorn --workers 3 --bind 0.0.0.0:8000 babyshop.wsgi:application
fi