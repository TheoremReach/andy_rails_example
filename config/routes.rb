Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: {format: 'json'} do
    namespace :v1, defaults: {format: 'json'} do
      resources :respondent_result, only: [:create]
      resources :survey_callback, only: [:create]
    end
  end

  get "/health_check", to: "static#health_check"

  get "/" => redirect("https://google.com")
end
