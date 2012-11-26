FactoryGirl.define do
  factory :heracles_remote_asset, class: Heracles::RemoteAsset do
    data File.read(__FILE__)
    sequence(:name) { |n| "name-#{n}"}
    content_type 'text/plain'
    sequence(:location) {|n| "http://somewhere.org/path/to/#{n}-item" }
    code 200
    sequence(:md5_checksum) { |n| "fake-md5-checksum-#{n}" }
    initialize_with { new(data, name, content_type, location, code) }
  end
end
