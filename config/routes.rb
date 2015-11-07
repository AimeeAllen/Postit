PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/register', to: 'users#new', as: 'users'
  post '/register', to: 'users#create'

  # can I simplify these as resources but with mapping?
  get '/users/:username', to: 'users#show'
  get '/users/:username/edit', to: 'users#edit'
  post '/users/:username', to: 'users#update'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :posts, except: :destroy do
    resources :comments, only: :create
  end
  resources :categories, only: [:index, :new, :create, :show]
  # I don't seem to be able to get rid of these routes when using model backed forms
  resources :users, only: [:edit, :update] #show, create

end
