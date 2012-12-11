require 'spec_helper'
require 'rack/qiniu_mock/context'

module Rack::QiniuMock
  describe Context do
    include Rack::Test::Methods

    def app
      Context.new(nil)
    end

    it 'should works' do
      get '/'
    end
  end
end
