class Users::SessionsController < Devise::SessionsController
  layout "simple", only: [:new]
end