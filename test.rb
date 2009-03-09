# Require all *.rb files in test directory
Dir::foreach('test') do |entry|
  if entry.match(/(.*)\.rb$/)
    require "test/#{$1}"
  end
end
