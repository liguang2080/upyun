require File.expand_path(File.dirname(__FILE__) + "/upyun/version")
require File.expand_path(File.dirname(__FILE__) + "/upyun/bucket")


module Upyun
  def self.get_config_for_bucket(bucket)
    UP_BUCKETS.find {|k, v| v.bucket_name.to_s == bucket.to_s}.try(:last)
  end
  
  # 为给定的路径与文件名生成保存后的远程路径
  def self.rand_save_path(filename)
    "/#{Date.today.year}/#{'%2s' % Date.today.month.to_s.rjust(2, "0")}/#{RandomCode.mix_string(32).downcase}#{File.extname(filename)}"
  end
end