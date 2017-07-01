Rails.application.routes.draw do
  namespace :v1 do
    get 'ping', to: 'ping#ping'
    get 'workshops/*all', constraints: { all: /.*/ }, to: 'workshops#workshops'

    post 'leaders/intake'
    post 'cloud9/send_invite'

    resources :clubs
    resources :tech_domain_redemptions, only: [:create]

    namespace :hackbot do
      post 'auth', to: 'auth#create'

      namespace :webhooks do
        post 'interactive_messages'
        post 'events'
      end
    end
  end
end
