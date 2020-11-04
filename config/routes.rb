Rails.application.routes.draw do
  resources :tipos
  resources :monedas
  resources :partidas
  get '/empleados/asesores', to: 'empleados#asesores'
  resources :empleados

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

  get '/requisiciones_netmultix/constancia_existencia/:requisicion/:responsable', to: 'requisiciones_netmultix#constancia_existencia'

  get '/proyectos_netmultix/search/:proyecto', to: 'proyectos_netmultix#search'

  put '/justificaciones/add_anexo/:id', to: 'justificaciones#add_anexo'
  get '/justificaciones/get_anexos/:justificacion_id', to: 'justificaciones#get_anexos'
  delete '/justificaciones/remove_anexo/:id/:idx', to: 'justificaciones#remove_anexo'

  get '/proveedores/send_focon04/:id/:justificacion_id', to: 'proveedores#send_focon04'

  resources :proveedores

end
