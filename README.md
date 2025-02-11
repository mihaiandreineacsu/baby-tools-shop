# E-Commerce Project For Baby Tools

## Table of Content

1. [TECHNOLOGIES](#technologies)
1. [Hints](#hints)
1. [Quickstart](#quickstart)
1. [Photos](#photos)

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

## Quickstart

### Nginx configuration (production)

```bash
# Create folders for static and media files with the correct permissions
sudo mkdir -p /vol/web/static /vol/web/media
sudo chown -R 1000:1000 /vol/web
sudo chmod -R 755 /vol/web

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

### Build Docker Image

```powershell
# Clone repository:
git clone https://github.com/mihaiandreineacsu/baby-tools-shop.git

# Navigate to repository folder:
cd baby-tools-shop

# Create environments file:
sudo touch .env

# Open the file, set the environments, save and close the file:
DJANGO_ALLOWED_HOSTS=your_public_ip_here
DJANGO_CSRF_TRUSTED_ORIGINS=your_csrf_trusted_origins

# Create docker volume for database:
docker volume create <database_volume_name>

# Build Docker Image for Development
docker build \
    -t <image_name>:<image_tag> . # -t babyshop:dev
# This will instruct:
# - the ENTRYPOINT to start Django development server
# - to sets Django DEBUG to True.

# Build Docker Image for Production
docker build \
    --build-arg DEV=False \ # --build-args DEV=True | False
    -t <image_name>:<image_tag> . \ # -t babyshop:prod

# This will instruct:
# - to sets Django DEBUG to False.
# - to install gunicorn
# - the ENTRYPOINT to collect statics and start Django using gunicorn
```

---

### Start the application

```powershell
# For development build, run:
docker run -it --rm \ # Create and run an interactive new container and remove the container when stopped
    --name <container_name> \ # Names the container: --name babyshop_dev
    -p 8000:8000 \ # Publish a container's port to the host.
    -v ${PWD}/babyshop_app:/app \ # Bind mount application source code (useful in development)
    -v <database_volume_name>:/database \ # -v babyshop_db:/database
    -v ${PWD}/vol:/vol \ # Bind mount the statics and media location (useful in development)
    <image_name>:<image_tag> # babyshop:dev

# For production build, run:
docker run -d \ # Create and run a detached new container
    --restart on-failure \ # Restarts the container only if it exits with a non-zero exit status
    --name <container_name> \ # Names the container: --name babyshop_prod
    -p 8000:8000 \ # In production this should match nginx configuration
    -v <database_volume_name>:/database \ # -v babyshop_db:/database
    -v /vol:/vol \ # In production this should match nginx configuration
    --env-file .env \ # Specify the file that contains the environment variables.
    <image_name>:<image_tag> # babyshop:prod

```

For development build, if you now navigate to [127.0.0.1:8000](http://127.0.0.1:8000) you should be able to open the application in your Browser.

---

### Create an admin user for Django

```powershell
# Execute this command:
docker exec -it <container_name> \ # docker exec -it babyshop_dev | babyshop_prod
    /py/bin/python /app/manage.py createsuperuser # Django command to start creating an admin user

# Then follow the prompts to create an admin user.
Username: <admin_username>
Email address: <admin_email>
Password: <admin_password>
Password (again): <admin_password>
Superuser created successfully.
```

After creating admin user, open your application in your Browser and navigate to [127.0.0.1:8000/admin](http://127.0.0.1:8000/admin). Here you can login to Django Admin panel using the provided username and password.

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

Demo example for Ishak
