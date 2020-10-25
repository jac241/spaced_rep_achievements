class GroupsController < ApplicationController

  def index
    @groups = Group.order(:name)
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
  end

  def create
    result = CreateGroupService.call(params: create_params, user: current_user)
    #@group = Group.new(create_params)

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
    params.require(:group).permit(:name, :description)
  end
end
