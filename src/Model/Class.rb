# Class.rb
# Generic representation of a 'Class' structure, from which we can generate a single diagram node
#
# (c) 2014 - Lars Lockefeer

class Class
  
  def initialize(name, superclass, protocols, properties, methods)
    
    @name = name
    @superclass = superclass
    @protocols = protocols
    @properties = properties
    @methods = methods
    
    @identifier = Class::generateIdentifierFromName(name)
    
  end
  
  attr_accessor :identifier
  attr_accessor :name
  attr_accessor :superclass
  attr_accessor :protocols
  attr_accessor :properties
  attr_accessor :methods
  
  def description
    
    description = String.new
    description += "Name: " + self.name.inspect + "\n"
    description += "Superclass: " + self.superclass.inspect + "\n"
    description += "Protocols: " + self.protocols.inspect + "\n"
    description += "Properties: " + self.properties.inspect + "\n"
    description += "Methods: " + self.methods.inspect + "\n"
    
    return description
    
  end
  
  def self.generateIdentifierFromName(name)
  
    classIdentifier = String.new
  
    classIdentifier = name.delete(")")
    classIdentifier.gsub!("(", "_")
    classIdentifier.strip!
  
    return classIdentifier
  
  end
  
end