Rails.application.routes.draw do
  get 'mediabrowser', to: 'scrivito_editors/mediabrowser#index'
  get 'mediabrowser/inspector', to: 'scrivito_editors/mediabrowser#inspector'
  get 'mediabrowser/modal', to: 'scrivito_editors/mediabrowser#modal'
end
