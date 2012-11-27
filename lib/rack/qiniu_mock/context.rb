require "mini_magick"

module Rack::QiniuMock
  class Context
    def initialize(app, opts={})
      @app = app
      @separator = '-'
      @suffixs = {
        "c698_250.jpg" => [:resize, '698x250'],
        "c660_600.jpg" => [:resize, '660x600'],
        'c660_400.jpg' => [:resize, '660x400'],
        'c400_300.jpg' => [:resize, '400x300'],
        'c350_227.jpg' => [:resize, '350x227'],
        'c218_600.jpg' => [:resize, '218x600'],
        'c218_134.jpg' => [:resize, '218x134'],
        'c200.jpg' => [:resize, '200x200'],
        'c175_115.jpg' => [:resize, '175x115'],
        'c158_105.jpg' => [:resize, '158x105'],
        'c100.jpg' => [:resize, '70x70'],
        'c59.jpg' => [:resize, '59x59'],
        'c49.jpg' => [:resize, '49x49'],
        "d146.jpg" => [:resize_with_crop, '146x146'],
        "d116.jpg" => [:resize_with_crop, '116x116'],
        "d73.jpg" => [:resize_with_crop, '73x73'],
        "d54.jpg" => [:resize_with_crop, '54x54'],
        "d49.jpg" => [:resize_with_crop, '49x49'],
      }
      @root = File.expand_path("public", Rails.root)
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

      original_path = @root + path.chomp(@separator + path_format)
      return nil unless File.exist?(original_path)

      res = MiniMagick::Image.open(original_path)
      [self.__send__(config[0], res, *config[1..-1]), File.mtime(original_path)]
    end
  end
end
