# Require all *.rb files in test directory
def canned_file(filename, format = :xml)
  file = File::read("test/data/#{filename}.#{format}")
  
  case format
  when :xml  then Hpricot.XML(file)
  when :json then HTTParty::Parsers::JSON.decode(file)
  else file
  end
end

Dir::foreach('test') do |entry|
  if entry.match(/(.*_test)\.rb$/)
    require "test/#{$1}"
  end
end
