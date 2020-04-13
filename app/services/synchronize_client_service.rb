class SynchronizeClientService
  include FlexibleService

  def call(user:, sync_params:)
    sync = user.syncs.create(sync_params)

    if sync.save
      SynchronizeClientJob.perform_later(sync)
      success(:created, sync)
    else
      failure(:invalid_params, sync)
    end
  end
end
