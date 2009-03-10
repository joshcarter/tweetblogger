require 'net/http'
require 'cgi'
require 'pp'

class HttpHelper
  def self.request(url, params = Hash.new)
    url = URI::parse(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if (url.scheme == 'https')

    # Request type defaults to get
    request = case params[:type]
    when :post then Net::HTTP::Post.new(url.request_uri, params[:headers])
    when :get  then Net::HTTP::Get.new(url.request_uri, params[:headers])
    else            Net::HTTP::Get.new(url.request_uri, params[:headers])
    end
    
    request.basic_auth(*params[:auth]) if params[:auth]
    request.form_data = params[:form_data] if params[:form_data]
    request.body = params[:body] if params[:body]

    http.start do |http|
      response = http.request(request)

      raise "Error #{response.code}: #{response.message}" unless response.kind_of?(Net::HTTPSuccess)

      return response.body
    end
  end
end

class String
  # Used for adding parameters to HTTP get requests
  def with_parameters(params = nil)
    s = self.dup

    if params && !params.empty?
      # Escape any nasty stuff in values
      params = params.map { |x| [x[0].to_s, CGI::escape(x[1].to_s)] }

      # Create composite URL with params
      s = s + '?' + params.map { |x| x.join('=') }.sort.join('&')
    end

    return s
  end
end