# Upyun

又拍云 ruby api

## Installation

Add this line to your application's Gemfile:

    gem 'upyun'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install upyun

## Usage

	up_client = UpYun::Bucket.new("by-test-upload", "ichihuo", "andy3197")
	res = up_client.writeFile("/test.png", File.new("test.png"))
	res['x-upyun-width']

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
