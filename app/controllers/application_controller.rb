class ApplicationController < ActionController::Base

    before_action :authenticate_user!,except: [:top]
    before_action :configure_permitted_parameters, if: :devise_controller?

    layout :select_layout

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

    def after_sign_in_path_for(resource)
        posts_path
    end

    private
    def select_layout
        if controller_name == "home" || devise_controller?
            "top"
        else
            "application"
        end
    end
end