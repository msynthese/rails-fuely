class RegistrationsController < Devise::RegistrationsController
  # def initialize
  #   @status = true
  # end
  def disable_false
    puts("disable_false")
    @status = false
  end

  private

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    stations_path
  end

  def after_sign_up_path_for(resource)
    edit_user_registration_path
  end


end
