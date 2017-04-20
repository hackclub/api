web: bin/rails server -p $PORT -e $RAILS_ENV
worker1: bundle exec rake jobs:work QUEUE=default
worker2: bundle exec rake jobs:work QUEUE=default
worker3: bundle exec rake jobs:work QUEUE=slack_events
worker4: bundle exec rake jobs:work QUEUE=slack_events
worker5: bundle exec rake jobs:work QUEUE=slack_events
worker6: bundle exec rake jobs:work QUEUE=slack_events
worker7: bundle exec rake jobs:work QUEUE=slack_events
worker8: bundle exec rake jobs:work QUEUE=slack_events
