FROM node:alpine as build-stage
WORKDIR /app
COPY ./frontend/package*.json ./
RUN npm install
COPY ./frontend/ .
RUN npm run build

FROM python:3

RUN apt-get update -y && \
    apt-get install -y python-pip python-dev

# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install -r requirements.txt

COPY ./mealie /app
COPY --from=build-stage /app/dist /app/dist


ENTRYPOINT [ "python" ]
# TODO Reconfigure Command to start a Gunicorn Server that managed the Uvicorn Server. Also Learn how to do that :-/
CMD [ "app.py" ] 