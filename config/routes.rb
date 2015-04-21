Rails.application.routes.draw do
  resources :emergencies, :responders, defaults: { format: 'json' }, only: :create

  patch '/responders/:name' => 'responders#update', defaults: { format: 'json' }
  get '/responders/:name' => 'responders#show', defaults: { format: 'json' }

  patch 'emergencies/:code' => 'emergencies#update', defaults: { format: 'json' }
end
