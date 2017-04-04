# Hack Club's Code [![CircleCI](https://circleci.com/gh/hackclub/api.svg?style=shield)](https://circleci.com/gh/hackclub/api) [![Code Climate](https://codeclimate.com/github/hackclub/api/badges/gpa.svg)](https://codeclimate.com/github/hackclub/api) [![Test Coverage](https://codeclimate.com/github/hackclub/api/badges/coverage.svg)](https://codeclimate.com/github/hackclub/api/coverage) [![security](https://hakiri.io/github/hackclub/api/master.svg)](https://hakiri.io/github/hackclub/api/master)

**Work in progress**

---

Detailed README coming soon.

## Setup

After cloning the repository, run the following commands:

```sh
$ docker-compose build
$ docker-compose run web bundle install
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
# You must also enable the timezone API in your Google Cloud account.
#
# Get a key from https://console.developers.google.com/flows/enableapi?apiid=geocoding_backend&keyType=SERVER_SIDE
GOOGLE_MAPS_API_KEY

# API key for Streak API. Must be an admin's key.
STREAK_API_KEY

# Keys for club, leader, and letter pipelines in Streak
STREAK_CLUB_PIPELINE_KEY
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

# Default Slack team ID (probably for Hack Club)
SLACK_TEAM_ID

# Secret code required when redeeming .tech domains
TECH_DOMAIN_REDEMPTION_SECRET_CODE

# The email of who to assign Streak tasks to
DEFAULT_STREAK_TASK_ASSIGNEE

# Slack channel to mirror Hackbot interactions to
HACKBOT_MIRROR_CHANNEL_ID

# Streak box to use for demo check-ins
STREAK_DEMO_USER_BOX_KEY
```

## Other Setup

Dumping this stuff here for lack of a better place.

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
