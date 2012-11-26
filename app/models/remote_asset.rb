unless defined?(RemoteAsset)
  RemoteAsset = Struct.new(
    :data,
    :name,
    :content_type,
    :location,
    :code,
    :md5_checksum
  )
end
