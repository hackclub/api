# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :v1 do
    get 'ping', to: 'ping#ping'

    get 'clubs/intake', to: 'intake#show'

    post 'leaders/intake'
    post 'cloud9/send_invite'

    resources :clubs, only: %i[index show]
    resources :athul_clubs, only: [:create]
    resources :tech_domain_redemptions, only: [:create]
    resources :slack_invites, only: [:create]
    resources :donations, only: [:create]
    resources :workshop_feedbacks, only: [:create]

    resources :workshops, param: :slug, only: [] do
      scope module: 'workshops' do
        resources :projects, only: %i[index create]
      end
    end

    resources :projects, only: [] do
      get 'redirect/:type_of',
          to: 'workshop_project_clicks#create',
          as: :redirect
    end

    resources :club_applications, only: [:create]

    get '/new_club_applications', to: 'new_club_applications#full_index'
    resources :new_club_applications, only: %i[show update] do
      post 'add_user'
      delete 'remove_user'

      post 'submit'
      post 'unsubmit'
      post 'accept'

      resources :notes, only: %i[index create]
    end

    resources :notes, only: %i[show update destroy]

    resources :leader_profiles, only: %i[show update]

    resources :new_clubs, only: %i[index show update] do
      collection do
        get 'owned', to: 'new_clubs#index_owned'

        scope module: 'new_clubs' do
          resources :information_verification_requests, only: [] do
            post 'verify'
          end
        end
      end

      resources :notes, only: %i[index create]

      post 'invite_leader', to: 'new_clubs/leadership_position_invites#create'
      get 'dumb_check_ins', to: 'new_clubs#check_ins_index'
    end

    resources :leadership_positions, only: %i[update destroy]
    resources :leadership_position_invites, only: [:show] do
      post 'accept'
      post 'reject'
    end

    resources :new_leaders, only: %i[show update] do
      resources :new_clubs, controller: 'new_leaders/new_clubs', only: [:index]
    end

    resources :users, only: %i[index show update] do
      collection do
        post 'auth'
        post 'auth_on_behalf'
        get 'current'
      end

      post 'exchange_login_code'
      post 'new_leader', to: 'users/new_leaders#create'

      resources :new_club_applications, only: %i[index create]
    end

    resources :events, only: %i[index create update destroy] do
      collection do
        scope module: 'events' do
          resources :groups, only: %i[index show]
        end
      end

      get 'redirect', to: 'event_website_clicks#create'

      resources :event_media, path: '/media', only: %i[index create destroy]
    end

    resources :event_email_subscribers, only: :create do
      collection do
        get 'confirm'
        get 'unsubscribe'

        get 'stats', to: 'event_email_subscribers/stats#index'
      end
    end

    resources :attachments, only: %i[create show]

    resources :challenges, only: %i[index create show] do
      resources :posts, controller: 'challenge_posts', only: %i[index create]
    end
    resources :posts, controller: 'challenge_posts', only: [] do
      resources :upvotes, controller: 'challenge_post_upvotes', only: %i[create]
      resources :comments,
                controller: 'challenge_post_comments',
                only: %i[index create]

      get :redirect, to: 'challenge_post_clicks#create'
    end
    resources :upvotes, controller: 'challenge_post_upvotes', only: %i[destroy]
    resources :post_comments,
              controller: 'challenge_post_comments',
              only: %i[update destroy]

    resources :utilities, only: [] do
      collection do
        post 'new_leader_exists'
      end
    end

    # Using 'bigbrother' as the path to get past ad-blockers
    post 'bigbrother/identify', to: 'analytics#identify'
    post 'bigbrother/track', to: 'analytics#track'
    post 'bigbrother/page', to: 'analytics#page'
    post 'bigbrother/group', to: 'analytics#group'

    namespace :hackbot do
      post 'auth', to: 'auth#create'

      namespace :webhooks do
        post 'interactive_messages'
        post 'events'
      end
    end
  end

  namespace :debug do
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      # Protect against timing attacks:
      # - See https://codahale.com/a-lesson-in-timing-attacks
      # - See https://thisdata.com/blog/timing-attacks-against-string-comparison
      # - Use & (do not use &&) so that it doesn't short circuit.
      # - Use digests to stop length information leaking (see also
      #   ActiveSupport::SecurityUtils.variable_size_secure_compare)
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(username),
        ::Digest::SHA256.hexdigest(
          Rails.application.secrets.sidekiq_http_username
        )
      ) & ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(password),
        ::Digest::SHA256.hexdigest(
          Rails.application.secrets.sidekiq_http_password
        )
      )
    end
    mount Sidekiq::Web, at: '/sidekiq'
  end
end
