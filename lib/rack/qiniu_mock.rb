module Rack
  module QiniuMock
    autoload :Context,      'rack/qiniu_mock/context'

    def self.new(app, options={}, &b)
      Context.new(app, options, &b)
    end
  end
end
