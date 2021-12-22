class ChaseModeConfigsController < ApplicationController
  before_action :authenticate_user!
  def edit
    @chase_mode_config = current_user.chase_mode_config
  end

  def update
    @chase_mode_config = current_user.chase_mode_config

    respond_to do |format|
      if @chase_mode_config.update(update_params)
        format.js do
          redirect_to edit_chase_mode_config_path,
                      notice: 'Chase mode settings successfully updated!'
        end
      else
        format.js { render :edit }
      end
    end
  end

  private

  def update_params
    params.require(:chase_mode_config).permit(:only_show_active_users)
  end
end
