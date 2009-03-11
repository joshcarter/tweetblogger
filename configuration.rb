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

class OpenStruct
  def to_hash
    hash = Hash.new
    
    @table.each_pair do |key, val|
      val = val.to_hash if val.class == OpenStruct
      hash[key.to_s] = val
    end
    
    return hash
  end
end

class Configuration
  def self.load(file)
    raise "No configuration file #{file}" unless File::readable?(file)
    return YAML::load(File.read(file)).to_struct
  end
  
  def self.save(config, file)
    File::open(file, 'w') { |f| f.write YAML::dump(config.to_hash) }
  end
end  

