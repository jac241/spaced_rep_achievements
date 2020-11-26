module Connection
  class ClientSocket
    alias_method :old_initialize, :initialize

    def initialize(env, event_target, event_loop, protocols)
      old_initialize(env, event_target, event_loop, protocols)
      @driver.add_extension(PermessageDeflate)
    end

  end
end
