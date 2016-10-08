Rails.application.routes.draw do
  namespace :v1 do
    get 'ping', to: 'ping#ping'

    post 'leaders/intake'

    resources :clubs
  end
end
