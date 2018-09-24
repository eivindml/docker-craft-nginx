![](readme-banner.png)

<p align="center">
Minmal working example of a Docker container for Craft CMS using nginx and alpine.
</p>

[![](https://images.microbadger.com/badges/image/eivindml/docker-craft-nginx.svg)](https://microbadger.com/images/eivindml/docker-craft-nginx "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/eivindml/docker-craft-nginx.svg)](https://microbadger.com/images/eivindml/docker-craft-nginx "Get your own version badge on microbadger.com")


## Goal

Current image size is `176MB`. The goal is `100MB` to deploy it using `zeit/now`.

## Usage

Rename `.env.example` to `.env` and edit the configurations.

```
docker-compose build
docker-compose up
```
