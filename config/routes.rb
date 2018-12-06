Rails.application.routes.draw do
  resources :tipos
  resources :monedas
  resources :partidas
  resources :empleados
  resources :proveedores
  resources :proveedores_netmultix
  resources :justificaciones

  get '/justificaciones/all_by_creador/:id', to: 'justificaciones#all_by_creador'

  get '/empleados/cuenta/:cuenta_cimav', to: 'empleados#cuenta', :constraints => { :cuenta_cimav => /([^\/]+?)(?=\.json|\.html|$|\/)/ }

  get '/cotizaciones/:id/:num_provee', to: 'justificaciones#cotizacion'
  get '/mercado/:id', to: 'justificaciones#mercado'

  get '/proveedores/by_justificacion/:justificacion_id', to: 'proveedores#by_justificacion'

  get '/justificaciones/all_by_creador/:id', to: 'justificaciones#all_by_creador'

  get '/justificaciones/replicar/:id/:identificador', to: 'justificaciones#replicar'

  get '/requisiciones_netmultix/search/:requisicion', to: 'requisiciones_netmultix#search'

end
