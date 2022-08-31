class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name avatar fuel_preference])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update,
                                    keys: %i[first_name last_name avatar fuel_preference])
  end

  private

  # Overwriting the sign_ou redirect path method
  def after_sign_out_path_for(resource)
    root_path
  end
end
