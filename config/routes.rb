Rails.application.routes.draw do
  get 'mediabrowser', to: 'scrival_editors/mediabrowser#index'
  get 'mediabrowser/inspector', to: 'scrival_editors/mediabrowser#inspector'
  get 'mediabrowser/modal', to: 'scrival_editors/mediabrowser#modal'
end
