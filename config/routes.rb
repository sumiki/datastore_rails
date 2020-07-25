Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  root 'contents#index'

  resources :login
  get 'logout' => 'login#logout'
  namespace :member do
    get '' => "menu#index"
    get 'menu' => "menu#index"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
