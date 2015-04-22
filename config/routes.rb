Rails.application.routes.draw do
  resources :responders, defaults: { format: 'json' }, only: [:create, :update, :show], param: :name
  resources :emergencies, defaults: { format: 'json' }, only: [:create, :update, :show], param: :code
end
