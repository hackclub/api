Rails.application.routes.draw do
  namespace :v1 do
    get 'ping', to: 'ping#ping'

    resources :clubs
  end
end
