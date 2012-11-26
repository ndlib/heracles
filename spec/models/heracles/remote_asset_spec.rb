require 'spec_helper'

describe Heracles::RemoteAsset do
  subject { FactoryGirl.build(:heracles_remote_asset) }
  it { subject.should respond_to(:data) }
  it { subject.should respond_to(:name) }
  it { subject.should respond_to(:content_type) }
  it { subject.should respond_to(:location) }
  it { subject.should respond_to(:code) }
  it { subject.should respond_to(:md5_checksum) }
end
