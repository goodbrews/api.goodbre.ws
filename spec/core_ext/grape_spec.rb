require 'spec_helper'

describe Grape do
  describe '.env' do
    it 'should create an ActiveSupport::StringInquirer' do
      Grape.env.should be_a(ActiveSupport::StringInquirer)
    end

    %w[development test production].each do |environment|
      context "in the #{environment} environment" do
        it "returns true from .#{environment}?" do
          ENV['GRAPE_ENV'] = environment
          Grape.env.send("#{environment}?").should be_true
        end
      end
    end

    after do
      Grape.instance_variable_set(:@env, nil)
    end
  end

  describe '.root' do
    it 'should be set to Dir.pwd' do
      Grape.root.should eq(Pathname.new(Dir.pwd))
    end

    it 'should join any paths passed to it' do
      Grape.root('app', 'apis').to_s.should eq("#{Dir.pwd}/app/apis")
    end
  end
end