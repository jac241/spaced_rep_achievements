module ActionCable
  module Connection
    class ClientSocket
      alias_method :old_initialize, :initialize
      alias_method :old_write, :write

      def initialize(env, event_target, event_loop, protocols)
        old_initialize(env, event_target, event_loop, protocols)
        @driver.add_extension(PermessageDeflate)
      end

      def write(data)
        old_write(data)
        Rails.logger.info "broadcasting: #{data.bytesize} bytes"
      end
    end
  end
end
