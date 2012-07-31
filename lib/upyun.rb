require File.expand_path(File.dirname(__FILE__) + "/upyun/version")
require File.expand_path(File.dirname(__FILE__) + "/upyun/bucket")


module Upyun
  def self.get_config_for_bucket(bucket)
    UP_BUCKETS.find {|k, v| v.bucket_name == bucket}.try(:last)
  end
end