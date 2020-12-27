module RawJsonBroadcasting
  extend ActiveSupport::Concern
  class_methods do
    def broadcast_json_to(model, json)
      ActionCable.server.broadcast(broadcasting_for(model), json, coder: nil)
    end
  end
end
