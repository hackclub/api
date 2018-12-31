<p align="center"><img alt="Monolith icon" src="https://i.imgur.com/GmQ9E9B.png"></a>
<h1 align="center">API</h1>
<p align="center"><i>The backend powering https://hackclub.com. Illustrated above.</i></p>
<p align="center">
  <a href="https://circleci.com/gh/hackclub/api">
    <img alt="CircleCI" src="https://img.shields.io/circleci/project/github/hackclub/monolith.svg">
  </a>
  <a href="https://oss.skylight.io/app/applications/WFTfslPPiTpG">
    <img alt="Skylight" src="https://badges.skylight.io/status/WFTfslPPiTpG.svg">
  </a>
</p>

testing github checks

## Development Setup

### Environment Variables

Create a file called `.env`. The following configuration options are available to set in it:

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

# The API key for our giffing engine. Can be requested from http://docs.guggy.com/,
# otherwise stealing the one from production will probably be find.
GUGGY_API_KEY

# Access token with all scopes enabled for the GitHub account to use as a bot.
GITHUB_BOT_ACCESS_TOKEN

# Credentials to a Stripe account
STRIPE_PUBLISHABLE_KEY
STRIPE_SECRET_KEY

# A list of channel IDs (comma separated) of channels which should have all new messages deleted from them.
CHANNELS_TO_CLEAR

# Segment analytics
SEGMENT_WRITE_KEY

# SMTP settings for sending emails like application confirmations
SMTP_ADDRESS
SMTP_PORT
SMTP_USERNAME
SMTP_PASSWORD
SMTP_DOMAIN

# Auth Token used when receiving a POST request to create an Athul club
ATHUL_AUTH_TOKEN

# HTTP auth to access Sidekiq's web interface
SIDEKIQ_HTTP_USERNAME
SIDEKIQ_HTTP_PASSWORD
```

### Build the container & install dependencies for runtime environment

    $ docker-compose build
    $ docker-compose run web bundle
    $ docker-compose run web rails db:create db:setup

Run tests to ensure everything is working as expected:

    $ docker-compose run web rails spec

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
