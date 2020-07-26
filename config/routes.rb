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

  get 'seeds' => 'seeds#index'
end
