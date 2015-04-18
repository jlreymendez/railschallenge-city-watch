Rails.application.routes.draw do
  resources :emergencies, :responders, defaults: { format: 'json' }
end
