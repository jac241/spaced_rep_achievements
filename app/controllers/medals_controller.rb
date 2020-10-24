class MedalsController < ApplicationController
  def index
    @families_with_medals = Family.all.includes(:medals)
  end
end
