unless defined?(Heracles::RemoteAsset)
  Heracles::RemoteAsset = Struct.new(
    :data,
    :name,
    :content_type,
    :location,
    :code,
    :md5_checksum
  )
end
