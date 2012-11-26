require 'spec_helper'

describe Heracles::ApiKey do

  context '#new' do
    it 'generates a new hash on save and hash is 32 hex characters' do
      a = Heracles::ApiKey.new
      a.key.should == nil
      a.save
      a.key.should =~ /^\h{32}$/
    end

    it 'preserves the hash over many saves' do
      a = Heracles::ApiKey.create
      first_key = a.key
      a.save
      a.key.should == first_key
    end

    it 'default value for is_alive is true' do
      a = Heracles::ApiKey.create
      a.is_alive.should == true
      b = Heracles::ApiKey.create(is_alive: false)
      b.is_alive.should == false
    end
  end

  context '.get_valid_key' do
    it 'will return an object with valid key' do
      a = Heracles::ApiKey.create(is_alive: true)
      a_key = a.key
      b = Heracles::ApiKey.get_valid_key(a_key)
      b.should_not == nil
      b.key.should == a_key
      b.id.should == a.id
    end
    it 'will not return a dead key' do
      dead = Heracles::ApiKey.create(is_alive: false)
      b = Heracles::ApiKey.get_valid_key(dead.key)
      b.should == nil
    end
  end
end
