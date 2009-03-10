require 'yaml'

class Hash
  def symbolize_keys
    new_hash = Hash.new
    
    self.each_pair do |key, val|
      val = val.symbolize_keys if val.class == Hash
      new_hash[key.to_sym] = val      
    end
    
    return new_hash
  end
end

class Configuration
  def self.load(file)
    YAML::load(File.read(file)).symbolize_keys
  end
end  

