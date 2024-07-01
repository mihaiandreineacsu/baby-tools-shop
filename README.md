# E-Commerce Project For Baby Tools

## Table of Content

1. [TECHNOLOGIES](#technologies)
1. [Hints](#hints)
1. [Photos](#photos)
1. [Quickstart](#quickstart)

## TECHNOLOGIES

- Python 3.9
- Django 4.0.2
- Gunicorn (production)
- Docker
- Nginx

## Hints

This section will cover some hot tips when trying to interacting with this repository:

- Settings & Configuration for Django can be found in [babyshop_app/babyshop/settings.py](./babyshop_app/babyshop/settings.py)

- Routing: Routing information, such as available routes can be found from any `urls.py` file in `babyshop_app` and corresponding subdirectories

- [Dockerfile](./Dockerfile) exposes the application on port 8000 and accepts a build argument DEV that can be set to "True" or "False". Default is "True"

  - DEV=True will set Django DEBUG variable to True and starts the application in Django development server
  - DEV=False will set Django DEBUG variable to False, installs gunicorn, collects statics and start the application using guincorn

- Entrypoint file [entrypoint.sh](./entrypoint.sh) is used as an ENTRYPOINT in [Dockerfile](./Dockerfile) to initiate and start Django App in development or production, based on the value of build argument DEV "True" or "False".

- Requirements can be found in [requirements.txt](./requirements.txt) file

- The commands examples in [Quickstart](#quickstart) for the host machine in development are in powershell

## Photos

### Home Page with login

<img alt="" src="./project_images/capture_20220323080815407.jpg"></img>

### Home Page with filter

<img alt="" src="./project_images/capture_20220323080840305.jpg"></img>

#### Product Detail Page

<img alt="" src="./project_images/capture_20220323080934541.jpg"></img>

#### Home Page with no login

<img alt="" src="./project_images/capture_20220323080953570.jpg"></img>

#### Register Page

<img alt="" src="./project_images/capture_20220323081016022.jpg"></img>

#### Login Page

<img alt="" src="./project_images/capture_20220323081044867.jpg"></img>

## Quickstart

### Build Docker Image

```powershell
# Clone repository:
git clone https://github.com/mihaiandreineacsu/baby-tools-shop.git

# Create docker volume for database:
docker volume create <database_volume_name>

# Build Docker Image for Development
docker build -t <image_name>:<image_tag> .
# This will instruct:
# - the ENTRYPOINT to start Django development server
# - to sets Django DEBUG to True.

# Build Docker Image for Production
docker build --build-arg DEV=False -t <image_name>:<image_tag> .
# This will instruct:
# - to sets Django DEBUG to False.
# - to install gunicorn
# - the ENTRYPOINT to collect statics and start Django using gunicorn
```

---

### Start the application

```powershell
# For development build, run:
docker run -it --name <container_name> --rm -p 8000:8000 -v ${PWD}/babyshop_app:/app -v <database_volume_name>:/database -v ${PWD}/vol:/vol <image_name>:<image_tag>

# For production build, run:
docker run --name <container_name> --rm --restart on-failure -p 8025:8000 -v <database_volume_name>:/database -v /vol:/vol <image_name>:<image_tag>

```

Let's break down the commands:

- "docker run -it --name <container_name> --rm  --restart on-failure" : Create and run a new container from an image, give it a name and remove the container when stopped.
- "-p 8025:8000" : Publish a container's port(s) to the host
- "-v ${PWD}/babyshop_app:/app" : Bind mount application source code (useful in development)
- "-v <database_volume_name>:/database": Bind mount database volume to docker's container location "/database" (See  [Django DATABASES Settings](./babyshop_app/babyshop/settings.py))
- "-v ${PWD}/vol:/vol" : Bind mount the statics and media location (useful in development)
- "-v /vol:/vol" : Bind mount the statics and media location (in production, required to serve the files via webserver)

For development build, if you now navigate to [127.0.0.1:8000](http://127.0.0.1:8000) you should be able to open the application in your Browser.

---

### Nginx configuration (production)

```bash
# Create nginx configuration file:
sudo touch /etc/nginx/sites-enabled/babyshop
```

```nginx
# Then give it this content:
server {
    listen 8025;
    listen [::]:8025;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static {
        alias /vol/web/static;
    }

    location /media {
        alias /vol/web/media;
    }
}
```

```bash
# Checked nginx configuration for errors:
sudo nginx -t

# Restart nginx service:
sudo systemctl restart nginx
```

---

### Create an admin user for Django

```powershell
# Execute this command:
docker exec -it <container_name> /py/bin/python /app/manage.py createsuperuser

# Then follow the prompts to create an admin user.
Username: <admin_username>
Email address: <admin_email>
Password: <admin_password>
Password (again): <admin_password>
Superuser created successfully.
```

After creating admin user, open your application in your Browser and navigate to `/admin`. Here you can login to Django Admin panel using the provided username and password.
