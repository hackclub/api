> _⚠️ GitHub & Heroku have turned off their integration while investigating a [breach](https://github.blog/2022-04-15-security-alert-stolen-oauth-user-tokens/), so changes will not automatically deploy after pushing to `main`. If you have access to do so, please [push your changes to the `main` branch of the Heroku git remote](https://devcenter.heroku.com/articles/git) once your PR is merged. Otherwise, please mention it in the PR and assign [@garyhtou](https://github.com/garyhtou) or [@maxwofford](https://github.com/maxwofford) for review._

<p align="center"><img alt="Monolith icon" src="https://i.imgur.com/GmQ9E9B.png"></a>
<h1 align="center">API</h1>
<p align="center"><i>The backend powering https://hackclub.com. Illustrated above by <a href="https://gh.maxwofford.com">@maxwofford</a>.</i></p>
<p align="center">
  <a href="https://circleci.com/gh/hackclub/api">
    <img alt="CircleCI" src="https://img.shields.io/circleci/project/github/hackclub/monolith.svg">
  </a>
  <a href="https://oss.skylight.io/app/applications/WFTfslPPiTpG">
    <img alt="Skylight" src="https://badges.skylight.io/status/WFTfslPPiTpG.svg">
  </a>
</p>

## Getting Started

Install [rbenv](https://github.com/rbenv/rbenv)

```bash
brew install rbenv
```

Install [bundler](https://bundler.io/)

```bash
gem install bundler -v 1.17.3
```

Run bundler

```bash
bundle install
```

Copy .env.example to .env

```
cp .env.example .env
```

Create and migrate database

```bash
bundle exec rake db:drop db:create db:migrate
```

Run the application

```bash
bin/rails s
```

Browse to [localhost:3000](http://localhost:3000)

## Alternative with Docker

Copy .env file

```bash
cp .env.docker.example .env.docker
```

Run Docker

```bash
docker-compose build
docker-compose run web bundle install
#docker-compose run web yarn install --check-files
docker-compose run web bundle exec rails db:drop db:create db:migrate
docker-compose run --service-ports web bundle exec rails s -b 0.0.0.0 -p 3000
```

## Other Development Setup

### Setting up the integrated Slack bot

1. Create a new Slack app on Slack
2. Create one (and only one) bot user and set "Always Show My Bot as Online" to "On"
3. Click "Event Subscriptions" on the sidebar in the left and set the request URL to `HOSTNAME/v1/hackbot/webhooks/events`, replacing `HOSTNAME` with your actual hostname.
4. Subscribe to the following bot events: `message.channels`, `message.im`, `message.groups`, `message.mpim`
5. Click "Interactive Messages" on the left sidebar and set the request URL to `HOSTNAME/v1/hackbot/webhooks/interactive_messages`, replacing `HOSTNAME` with your actual hostname.
6. Manually go through the Oauth flow and POST `code` to `/v1/hackbot/auth`

## Production Setup

### Scheduled Jobs

This application depends on a few jobs running periodically in the background. Set this up using cron or a similar scheduler on your deployment of the application -- we use Heroku's scheduler in production.

- `rails heroku_scheduler:queue_update_hackbot_slack_username_job` hourly
- `rails heroku_scheduler:queue_record_slack_stats_job` daily
- `rails heroku_scheduler:queue_activate_clubs_job` daily
- `rails heroku_scheduler:queue_collect_projects_shipped_job` daily
- `rails heroku_scheduler:queue_schedule_leader_check_ins_job` daily
- `rails heroku_scheduler:queue_handle_spam_club_applications_job` every 10 minutes
- `rails heroku_scheduler:queue_update_from_streak_job` hourly
- `rails heroku_scheduler:queue_close_check_ins_job` daily

### Deployment on Heroku

We use Heroku for managing our deployment of this project and that brings along some special caveats. Specifically, we rely on multiple buildpacks.

Here are the buildpacks that need to be configured (they must be in the given order):

```
https://github.com/heroku/heroku-buildpack-activestorage-preview
https://github.com/heroku/heroku-buildpack-apt
heroku/ruby
```

Refer to https://devcenter.heroku.com/articles/buildpacks for instructions on configuring buildpacks.

### Profiling

We use [Skylight](https://www.skylight.io) to profile the performance of our backend in production. To use it, you must set `SKYLIGHT_AUTHENTICATION` in the environment to the value that Skylight gives you.

