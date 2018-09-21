# Docker Craft Nginx

Minmal working example of a Docker container for Craft CMS using nginx and alpine.

## Goal

Current image size is `176MB`. The goal is `100MB` to deploy it using `zeit/now`.

## Usage

Rename `.env.example` to `.env` and edit the configurations.

```
docker-compose build
docker-compose up
```
