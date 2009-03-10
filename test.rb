# Require all *.rb files in test directory
def canned_file(filename, format = :xml)
  File::read("test/data/#{filename}.#{format}")
end

Dir::foreach('test') do |entry|
  if entry.match(/(.*_test)\.rb$/)
    require "test/#{$1}"
  end
end
