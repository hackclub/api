# Hack Club's Code [![CircleCI](https://circleci.com/gh/hackclub/code.svg?style=shield)](https://circleci.com/gh/hackclub/code) [![Code Climate](https://codeclimate.com/github/hackclub/code/badges/gpa.svg)](https://codeclimate.com/github/hackclub/code)

**Work in progress**

---

Detailed README coming soon.

## Setup

After cloning the repository, run the following commands:

```sh
$ docker-compose build
$ docker-compose run web rails db:create
$ docker-compose run web rails db:migrate
$ docker-compose up
```

And then the server should be live!

## Configuration

The following configuration options are available:

```
# Number of Rails threads to run per server instance. One database connection is
# made per thread (ex. if this is set to 5, then the database connection pool
# will hold 5 connections).
RAILS_MAX_THREADS

# Port to listen for HTTP requests on
PORT

# Environment to run Rails in (can be "development", "test", or "production")
RAILS_ENV

# URL of Postgres instance to connect to. Rails will automatically connect to
# Docker Compose's instance of Postgres if this isn't set.
DATABASE_URL

# API key for Google Maps geocoding API.
#
# Get a key from https://console.developers.google.com/flows/enableapi?apiid=geocoding_backend&keyType=SERVER_SIDE
GOOGLE_MAPS_API_KEY

# API key for Streak API. Must be an admin's key.
STREAK_API_KEY

# Keys for club and leader pipelines in Streak
STREAK_CLUB_PIPELINE_KEY
STREAK_LEADER_PIPELINE_KEY
```
