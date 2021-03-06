# https://github.com/heartcombo/devise/wiki/How-To:-Redirect-to-a-specific-page-on-successful-sign-up-(registration)

class RegistrationsController < Devise::RegistrationsController

  # override destroy to destroy with job
  def destroy
    if resource.is_a?(User)
      DestroyUserJob.perform_later(resource.id)
    else
      resource.destroy
    end

    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  protected

  def after_sign_up_path_for(resource)
    '/connect'
  end

  def after_inactive_sign_up_path_for(resource)
    '/connect'
  end
end
