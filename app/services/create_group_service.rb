class CreateGroupService
  include FlexibleService

  def call(params:, user:)
    create_group!(params, user)
  rescue ActiveRecord::RecordInvalid => e
    failure(:record_invalid, e.record)
  end

  private

  def create_group!(params, user)
    Group.transaction do
      group = Group.create!(params)

      group.memberships.create!(member: user, admin: true)

      success(:created, group)
    end
  end
end
