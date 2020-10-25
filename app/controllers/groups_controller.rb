class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = Group.order(:name)
    @groups_current_user_belongs_to = current_user.groups.pluck(:id).to_set
    @groups_current_user_requesting_to_join = current_user.requested_groups.pluck(:id).to_set
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
  end

  def create
    result = CreateGroupService.call(params: create_params, user: current_user)

    if result.success?
      respond_to do |format|
        format.js { redirect_to result.body }
      end
    else
      respond_to do |format|
        @group = result.body

        format.js { render :new }
      end
    end
  end

  private

  def create_params
    params.require(:group).permit(:name, :description, :public)
  end
end
