require 'net/http'
require 'uri'
require "base64"
require 'digest/md5'

module Upyun
  class Bucket
    attr_accessor :bucketname, :username, :password
    attr_accessor :api_domain, :api_form_secret

    def initialize(bucketname, username, password, options = {})
      options = { :api_domain => "v0.api.upyun.com", :api_form_secret => "" }.merge(options)
      @bucketname = bucketname
      @username = username
      @password = Digest::MD5.hexdigest(password)
      @api_domain = options[:api_domain]
      @api_form_secret = options[:api_form_secret]
    end

    def write_file(filepath, fd, mkdir='true')
      url = "http://#{api_domain}/#{bucketname}#{filepath}"
      uri = URI.parse(URI.encode(url))

      Net::HTTP.start(uri.host, uri.port) do |http|
        date = get_gmt_date
        length = File.size(fd)
        method = 'PUT'
        headers = {
          'Date' => date,
          'Content-Length' => length.to_s,
          'Authorization' => sign(method, get_gmt_date, "/#{@bucketname}#{filepath}", length),
          'mkdir' => mkdir
        }
        
        http.send_request(method, uri.request_uri, fd.read, headers)
      end
    end
    
    # 生成api使用的policy 以及 signature  可以是图片或者是文件附件 图片最大为1M 文件附件最大为5M
    def api_form_params(file_type = "pic", notify_url = "", return_url = "", expire_date = 1.days)
      policy_doc = {
        "bucket" => bucketname,
        "expiration" => (DateTime.now + expire_date).to_i,
        "save-key" => "/{year}/{mon}/{random}{.suffix}",
        "notify-url" => notify_url,
        "return-url" => return_url
      }
      
      policy_doc = policy_doc.merge({"allow-file-type" => "jpg,jpeg,gif,png", "content-length-range" => "0,1048576"}) if file_type == "pic"
      policy_doc = policy_doc.merge({"allow-file-type" => "doc docx xls xlsx ppt txt zip rar", "content-length-range" => "0,5242880"}) if file_type == "file"
      
      policy = Base64.encode64(policy_doc.to_json).gsub("\n", "").strip
      signature = Digest::MD5.hexdigest(policy + "&" + api_form_secret)
      
      {:policy => policy, :signature => signature}
    end
    
    def parse_notify_params(params)
      if params[:code] == "200" && (params[:sign] == Digest::MD5.hexdigest("#{params[:code]}&#{params[:message]}&#{params[:url]}&#{params[:time]}&#{api_form_secret}"))
        url = "http://#{bucketname}.b0.upaiyun.com#{params[:url]}"
        mid = Digest::MD5.hexdigest(url)
        image_attributes = { :mid => mid, :url => url }
        
        if params["image-width"] && params["image-height"] && params["image-frames"] && params["image-type"]
          image_attributes[:width] = params["image-width"].to_i
          image_attributes[:height] = params["image-height"].to_i
          image_attributes[:frames] = params["image-frames"].to_i
          image_attributes[:file_type] = params["image-type"]
        end
        image_attributes
      else
        nil
      end
    end

    private
    def get_gmt_date
      DateTime.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
    end

    def sign(method, date, url, length)
      sign = "#{method}&#{url}&#{date}&#{length}&#{password}"
      "UpYun #{@username}:#{Digest::MD5.hexdigest(sign)}"
    end
  end
end
