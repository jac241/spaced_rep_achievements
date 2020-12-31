class ApplicationSerializer
  include JSONAPI::Serializer

  def self.cache_with_default_options
    cache_options store: Rails.cache, namespace: 'jsonapi-serializer'
  end
end
