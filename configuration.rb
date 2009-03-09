require 'yaml'
require 'cgi'

class Configuration < Hash
  def self.symbolize_keys(hash)
    new_hash = Hash.new
    
    hash.each_pair do |key, val|
      val = symbolize_keys(val) if val.class == Hash
      new_hash[key.to_sym] = val      
    end
    
    return new_hash
  end
  
  def self.load(file)
    symbolize_keys(YAML::load(File.read(file)))
  end
end  

class String
  def with_parameters(params = nil)
    s = self.dup
    
    if params && !params.empty?
      # Escape any nasty stuff in values
      params = params.map { |x| [x[0], CGI::escape(x[1])] }
      
      # Create composite URL with params
      s = s + '?' + params.map { |x| x.join('=') }.sort.join('&')
    end
    
    return s
  end
end