Rails.application.routes.draw do
  # General resource cases
  resources :responders, defaults: { format: 'json' }, only: [:create, :update, :show, :index], param: :name
  resources :emergencies, defaults: { format: 'json' }, only: [:create, :update, :show, :index], param: :code

  # 404 errors
  match '*path', to: 'application#catch_404', defaults: { format: 'json' }, via: :all
end
