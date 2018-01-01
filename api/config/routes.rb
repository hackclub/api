# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1 do
    get 'ping', to: 'ping#ping'
    get 'repo/*all', constraints: { all: /.*/ }, to: 'repo#file'

    get 'clubs/intake', to: 'intake#show'

    post 'leaders/intake'
    post 'cloud9/send_invite'

    resources :clubs, only: %i[index show]
    resources :athul_clubs, only: [:create]
    resources :tech_domain_redemptions, only: [:create]
    resources :donations, only: [:create]

    resources :club_applications, only: [:create]
    resources :new_club_applications, only: %i[show update] do
      post 'add_applicant'
      delete 'remove_applicant'
      post 'submit'
    end

    resources :applicant_profiles, only: %i[show update]

    resources :applicants, except: :all do
      collection do
        post 'auth'
      end

      post 'exchange_login_code'

      resources :new_club_applications, only: %i[index create]
    end

    namespace :home do
      resources :slack_users, only: [:index]
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

    namespace :slack_invitation do
      resources :invite, only: %i[create show]
      resources :webhook, only: [:create]
      resources :strategies, only: [:show]
    end
  end
end
