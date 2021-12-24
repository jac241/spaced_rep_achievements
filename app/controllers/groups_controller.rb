class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update]

  def index
    @groups = Group.order(:name)
    @my_groups = current_user.groups.load
    @ids_of_groups_current_user_belongs_to = current_user.groups.pluck(:id).to_set
    @ids_of_groups_current_user_requesting_to_join = current_user.requested_groups.pluck(:id).to_set
  end

  def new
    @group = Group.new
  end

  def show
    authorize @group

    leaderboard_results = FindLeaderboardService.call(
      user: current_user,
      maybe_family_slug: params[:family_id],
      maybe_timeframe: params[:timeframe]
    )

    leaderboard_results.on(:found) do |leaderboard|
      @leaderboard = LeaderboardDecorator.new(
        GroupLeaderboard.new(leaderboard, @group)
      )
      @families = Family.all
      @timeframes = Leaderboard.timeframes
      @membership_for_current_user = @group.memberships.find_by(member: current_user)
    end
  end

  def edit
    authorize @group
  end

  def update
    authorize @group

    respond_to do |format|
      if @group.update(update_params)
        format.js { redirect_to @group, notice: 'Group successfully updated!' }
      else
        format.js { render :edit }
      end
    end
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

  def set_group
    @group = Group.find(params[:id])
  end

  def create_params
    params.require(:group).permit(
      :name, :description, :public, :tag, :color, :tag_text_color
    )
  end

  def update_params
    create_params
  end
end
