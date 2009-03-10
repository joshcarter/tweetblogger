require 'yaml'
require 'ostruct'

class Hash
  def to_struct
    struct = OpenStruct.new
    
    self.each_pair do |key, val|
      val = val.to_struct if val.class == Hash
      struct.send((key + '=').to_sym, val)
    end
    
    return struct
  end
end

class Configuration
  def self.load(file)
    YAML::load(File.read(file)).to_struct
  end
end  

