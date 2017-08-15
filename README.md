# Monolith

**Table of Contents**

- [Monolith](#monolith)
  - [Setup](#setup)
  - [Frontend Configuration](#frontend-configuration)
  - [API Configuration](#api-configuration)
    - [Environmental Variables](#environmental-variables)
    - [Setting up the Slack App](#setting-up-the-slack-app)
    - [Scheduled Jobs](#scheduled-jobs)
    - [Deployment on Heroku](#deployment-on-heroku)

## Setup

```sh
git submodule init
git submodule update
docker-compose build
docker-compose run api bundle
docker-compose run api rails db:create db:migrate
docker-compose run frontend yarn
docker-compose up
```

And then `api` and `frontend` should be live!

## Frontend Configuration

Create a file called `./frontend/.env` with the following contents, replacing "REPLACEME" with actual values:

```
REACT_APP_META_TITLE=REPLACEME
REACT_APP_META_DESCRIPTION=REPLACEME
REACT_APP_META_OG_IMAGE=REPLACEME

# For building the "og:image" meta tag
REACT_APP_FRONTEND_BASE_URL=REPLACEME

# For Hackbot new team auth
REACT_APP_SLACK_CLIENT_ID=REPLACEME

# For the donations page
REACT_APP_STRIPE_PUBLISHABLE_KEY=REPLACEME

# For error tracking
REACT_APP_SENTRY_DSN=REPLACEME

# For Google analytics
REACT_APP_GOOGLE_ANALYTICS_ID=REPLACEME
```

## API Configuration

### Environmental Variables

Create a file called `./api/.env`. The following configuration options are available to set in it:

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
# You must also enable the timezone API in your Google Cloud account.
#
# Get a key from https://console.developers.google.com/flows/enableapi?apiid=geocoding_backend&keyType=SERVER_SIDE
GOOGLE_MAPS_API_KEY

# API key for Streak API. Must be an admin's key.
STREAK_API_KEY

# Keys for application, club, leader, letter, and fundraising pipelines in Streak
STREAK_CLUB_APPLICATIONS_PIPELINE_KEY
STREAK_CLUB_PIPELINE_KEY
STREAK_FUNDRAISING_PIPELINE_KEY
STREAK_LEADER_PIPELINE_KEY
STREAK_LETTER_PIPELINE_KEY

# DSN for Sentry (https://sentry.io) (only needed for production)
SENTRY_DSN

# Name of team to put members of Hack Club into on Cloud9 & credentials for
# an account with access to that team.
CLOUD9_TEAM_NAME
CLOUD9_USERNAME
CLOUD9_PASSWORD

# Keys for school and teacher outreach pipelines
STREAK_OUTREACH_SCHOOL_PIPELINE_KEY
STREAK_OUTREACH_TEACHER_PIPELINE_KEY

# For Slack authentication
SLACK_CLIENT_ID
SLACK_CLIENT_SECRET

# For Slack invitation authentication (https://api.slack.com/custom-integrations/legacy-tokens) (make sure this is an admin's legacy-token)
SLACK_ADMIN_ACCESS_TOKEN

# For Slack stats authentication
SLACK_ADMIN_EMAIL
SLACK_ADMIN_PASSWORD

# Default Slack team ID (probably going to be T0266FRGM, which is Hack Club's
# team)
DEFAULT_SLACK_TEAM_ID

# Secret code required when redeeming .tech domains
TECH_DOMAIN_REDEMPTION_SECRET_CODE

# The email of who to assign Streak tasks to
DEFAULT_STREAK_TASK_ASSIGNEE

# Slack channel to mirror Hackbot interactions to
HACKBOT_MIRROR_CHANNEL_ID

# Comma separated list of Slack user IDs that Hackbot should recognize as
# admins. User IDs can be from multiple Slack teams.
HACKBOT_ADMINS

# Streak box to use for demo check-ins
STREAK_DEMO_USER_BOX_KEY

# API key to use with Giphy. Will probably be "dc6zaTOxFJmzC", which is their
# public beta key (see https://github.com/Giphy/GiphyAPI) for details.
GIPHY_API_KEY

# Access token with all scopes enabled for the GitHub account to use as a bot.
GITHUB_BOT_ACCESS_TOKEN

# Credentials to a Stripe account
STRIPE_PUBLISHABLE_KEY
STRIPE_SECRET_KEY

# SMTP settings for sending emails like application confirmations
SMTP_ADDRESS
SMTP_PORT
SMTP_USERNAME
SMTP_PASSWORD
SMTP_DOMAIN
```

### Setting up the Slack App

1. Create a new Slack app on Slack
2. Create one (and only one) bot user and set "Always Show My Bot as Online" to "On"
3. Click "Event Subscriptions" on the sidebar in the left and set the request URL to `HOSTNAME/v1/hackbot/webhooks/events`, replacing `HOSTNAME` with your actual hostname.
4. Subscribe to the following bot events: `message.channels`, `message.im`, `message.groups`, `message.mpim`
5. Click "Interactive Messages" on the left sidebar and set the request URL to `HOSTNAME/v1/hackbot/webhooks/interactive_messages`, replacing `HOSTNAME` with your actual hostname.

### Scheduled Jobs

This application depends on a few jobs running periodically in the background. Set this up using cron or a similar scheduler on your deployment of the application -- we use Heroku's scheduler in production.

- `rails heroku_scheduler:queue_update_from_streak` every hour
- `rails heroku_scheduler:queue_update_hackbot_slack_username` every hour

### Deployment on Heroku

We use Heroku for managing our deployment of this project and that brings along some special caveats. Specifically, we rely on multiple buildpacks.

Here are the buildpacks that need to be configured (they must be in the given order):

```
https://github.com/heroku/heroku-buildpack-apt
heroku/ruby
```

Refer to https://devcenter.heroku.com/articles/buildpacks for instructions on configuring buildpacks.
