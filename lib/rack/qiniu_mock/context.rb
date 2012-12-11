require "mini_magick"
require 'yaml'

module Rack::QiniuMock
  class Context
    def initialize(app, opts={})
      @app = app
      @root = defined?(Rails) ? Rails.root : Dir.pwd
      @root_public = File.expand_path("public", @root)
      @config = YAML.load_file(File.expand_path("config/qiniu_mock.yml", @root))
      @separator = @config['separator'] || '-'
      @suffixs = @config['suffixs'] || {}
      yield self if block_given?
    end

    def call(env)
      original_file, mtime = get_original_file(::Rack::Utils.unescape(env['PATH_INFO']))
      if original_file
        data = original_file.to_blob
        [200, {
          "Content-Type" => original_file.mime_type,
          "Content-Length" => data.size.to_s,
          "Cache-Control" => "public, max-age=31536000",
          "Last-Modified" => mtime.httpdate
          }, [data]]
      else
        @app.call(env)
      end
    end

    private
    def resize(image, size)
      image.resize size
      image
    end

    def resize_with_crop(image, size)
      image.combine_options do |c|
        c.resize "#{size}^"
        c.gravity "center"
        c.crop "#{size}+0+0"
      end
      image
    end

    def get_original_file(path)
      path_format = path.split(@separator)[-1]

      config = @suffixs[path_format]
      return nil if config.nil?

      original_path = @root_public + path.chomp(@separator + path_format)
      return nil unless File.exist?(original_path)

      res = MiniMagick::Image.open(original_path)
      [self.__send__(config[0], res, *config[1..-1]), File.mtime(original_path)]
    end
  end
end
