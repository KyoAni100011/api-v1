require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post :login, to: "authen#login"
        post :register, to: "authen#register"
        delete :logout, to: "authen#logout"
        get :me, to: "authen#me"
      end

      resources :posts
    end
  end
end