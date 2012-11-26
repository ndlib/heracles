require_relative '../spec_helper'

describe RemoteAsset do
  subject { FactoryGirl.build(:remote_asset) }
  it { subject.should respond_to(:data) }
  it { subject.should respond_to(:name) }
  it { subject.should respond_to(:content_type) }
  it { subject.should respond_to(:location) }
  it { subject.should respond_to(:code) }
  it { subject.should respond_to(:md5_checksum) }
end
