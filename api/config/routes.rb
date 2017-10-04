# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  namespace :v1 do
    get 'ping', to: 'ping#ping'
    get 'workshops/*all', constraints: { all: /.*/ }, to: 'workshops#workshops'

    get 'clubs/intake', to: 'intake#show'

    post 'leaders/intake'
    post 'cloud9/send_invite'

    resources :clubs, only: [:index, :show]
    resources :club_applications, only: [:create]
    resources :tech_domain_redemptions, only: [:create]
    resources :donations, only: [:create]

    namespace :home do
      resources :slack_users, only: [:index]
    end

    namespace :hackbot do
      post 'auth', to: 'auth#create'

      namespace :webhooks do
        post 'interactive_messages'
        post 'events'
      end
    end

    namespace :slack_invitation do
      resources :invite, only: [:create, :show]
      resources :webhook, only: [:create]
      resources :strategies, only: [:show]
    end
  end
end
# rubocop:enable Metrics/BlockLength
