# Rack::QiniuMock

[![Build Status](https://secure.travis-ci.org/rdd-giga/rack-qiniu_mock.png?branch=master)](https://travis-ci.org/rdd-giga/rack-qiniu_mock)

七牛云存储的开发辅助工具，方便地支持在本地进行图片缩放。

七牛云存储的反向代理CDN+图片缩放的服务很好用，但有一个问题，在开发环境下，无法享受到该服务。这个 gem 提供了在开发环境下模拟七牛云存储基本图片缩放的功能。

## 使用方法

完整的范例参考: https://github.com/lidaobing/paperclip-qiniu-example/tree/local_storage

* 将如下一行加入到你的 Rails 应用的 `Gemfile

```ruby
gem 'rack-qiniu_mock', :group => :development
```

* 在 `config/environments/development.rb` 中间加入如下一行

```ruby
config.middleware.insert_after ActionDispatch::Static, ::Rack::QiniuMock
```

* 创建 `config/qiniu_mock.yml`, 内容如下

```yaml
separator: '-'
suffixs:
  large: ['resize', '660x400']
  medium: ['resize', '220x150']
  small: ['resize_with_crop', '50x50']
```

* 下载 `https://raw.github.com/lidaobing/paperclip-qiniu-example/local_storage/config/initializers/qiniu_image.rb` 到 `config/initializers/qiniu_image.rb`

* 修改 image_tag 为如下的形式

```ruby
<%= image_tag qiniu_image(image.file, "medium")%>
```

其中 `image.file` 为 `Paperclip::Attachment`, `medium` 为你想使用的变换格式。


## TODO

* 合并 qiniu_image 到该 gem
* 支持其他格式类型

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
