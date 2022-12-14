class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[fuel_preference brand_preference capacity])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: %i[fuel_preference brand_preference capacity])
  end

  private

  # Overwriting the sign_in redirect path method
  def after_sign_in_path_for(resource)
    if current_user.fuel_preference.present?
      stations_path
    else
      edit_user_registration_path
    end
  end

  # Overwriting the sign_ou redirect path method
  def after_sign_out_path_for(resource)
    root_path
  end
end
