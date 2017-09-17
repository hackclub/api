Rails.application.routes.draw do
  namespace :v1 do
    get 'ping', to: 'ping#ping'
    get 'workshops/*all', constraints: { all: /.*/ }, to: 'workshops#workshops'

    get 'clubs/to_be_onboarded', to: 'clubs_to_be_onboarded#show'

    post 'leaders/intake'
    post 'cloud9/send_invite'

    resources :clubs, only: [:index, :show]
    resources :club_applications, only: [:create]
    resources :tech_domain_redemptions, only: [:create]
    resources :donations, only: [:create]

    namespace :hackbot do
      post 'auth', to: 'auth#create'

      namespace :webhooks do
        post 'interactive_messages'
        post 'events'
      end
    end

    namespace :slack_invitation do
      resources :invite, only: [:create]
      resources :webhook, only: [:create]
    end
  end
end
