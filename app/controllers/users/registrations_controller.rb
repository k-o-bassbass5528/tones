class Users::RegistrationsController < Devise::RegistrationsController
  layout "simple", only: [:new]
end
