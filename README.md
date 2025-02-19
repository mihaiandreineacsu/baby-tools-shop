# E-Commerce Project For Baby Tools

## Table of content

- [Technologies](#technologies)
- [Hints](#hints)
- [Quickstart](#quickstart)
- [Photos](#photos)

## Technologies

- Python 3.9
- Django 4.0.2
- Gunicorn (production)
- Docker
- Nginx

## Hints

This section will cover some hot tips when trying to interacting with this repository:

- Settings & Configuration for Django can be found in [`babyshop_app/babyshop/settings.py`](./babyshop_app/babyshop/settings.py)
- Routing: Routing information, such as available routes can be found from any `urls.py` file in `babyshop_app` and corresponding subdirectories
- Requirements can be found in [requirements.txt](./babyshop_app/requirements.txt) file
- [Dockerfile](./Dockerfile) a python:3.9-slim to run Django app
- To ignore specific files when build with docker, add them to [.dockerignore](./.dockerignore) file.

### Quickstart

```powershell
# Build Docker Image
docker build \
    -t babyshop:simple \ # -t <image_name>:<image_tag>
    -f Dockerfile . # -f <docker_file_name> <path_to_build_context>

# Start Docker Container
docker run -it --rm \ # # Create and run an interactive new container and remove the container when stopped
    --name babyshop_simple \ # -- name <container_name>
    -p 8025:8025 \ # Publish a container's port to the host.
    -v ${PWD}/babyshop_app:/app \ # Bind mount application source code
    babyshop:simple # <image_name>:<image_tag>
```

If you now navigate to [127.0.0.1:8025](http:127.0.0.1:8025) you should be able to open the application in your Browser.

- [Dockerfile](./Dockerfile) exposes the application on port 8000 and accepts a build argument DEV that can be set to "True" or "False". Default is "True"

#### Home Page with login

<img alt="" src="./project_images/capture_20220323080815407.jpg"></img>

#### Home Page with filter

<img alt="" src="./project_images/capture_20220323080840305.jpg"></img>

#### Product Detail Page

<img alt="" src="./project_images/capture_20220323080934541.jpg"></img>

#### Home Page with no login

<img alt="" src="./project_images/capture_20220323080953570.jpg"></img>

#### Register Page

<img alt="" src="./project_images/capture_20220323081016022.jpg"></img>

#### Login Page

<img alt="" src="./project_images/capture_20220323081044867.jpg"></img>
