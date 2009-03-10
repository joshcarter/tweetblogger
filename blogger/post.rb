require 'builder'

module Blogger
  class Post
    def initialize(title, body)
      @title = title
      @body = body
    end
    
    def atom_formatted
      b = Builder::XmlMarkup.new(:indent => 2)
      xml = b.entry(:xmlns => 'http://www.w3.org/2005/Atom') do
        b.title(@title, :type => 'text')
        b.content(:type => 'xhtml') do
          b << @body
        end
      end
      
      return xml
    end
  end
end
