# Graph.rb
# Represents a property of a 'Class'
#
# (c) 2014 - Lars Lockefeer

class Property
  
  def initialize(type, name)
    @type = type.strip
    @name = name.strip
  end
  
  attr_accessor :type
  attr_accessor :name
  
end