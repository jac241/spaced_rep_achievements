class BattlePassesController < ApplicationController
  before_action :authenticate_user!
  def show
    @battle_pass = current_user.battle_passes.last
  end
end
