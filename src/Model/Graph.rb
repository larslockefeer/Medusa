# Graph.rb
# Represents a graph of interconnected and related 'Class' instances
#
# (c) 2014 - Lars Lockefeer

class Graph
  
  def initialize()
    
    @nodes = Hash.new
    @associations = Hash.new
    @inheritances = Hash.new
    @implementations = Hash.new
    
  end
  
  attr_accessor :associations
  attr_accessor :nodes
  
  def addNode(node)
    
    @nodes[node.identifier] = node
    @associations[node.identifier] = Array.new
    @implementations[node.identifier] = Array.new
    
  end
  
  # TODO: We really want to factor out graph generation to a separate class
  def generate
    
    generateAssociations()
    generateImplementations()
    generateInheritance()
    
    graph = String.new
    
    graph += preamble()
    
    @nodes.each do |nodeIdentifier, node|
      
      graph += graphItemForNode(node)
      
    end
    
    graph += graphAssociations()
    graph += graphInheritances()
    graph += graphImplementations()
    graph += postamble()
    
    return graph
    
  end
  
  private
  
  def generateAssociations
    
    @nodes.each do |nodeIdentifier, node|
    
      node.properties.each do |property|
        
        identifier = Class::generateIdentifierFromName(property.type)
        if identifier.length > 0 and @nodes.has_key?(identifier)
          
          @associations[node.identifier].push(identifier)
      
        end
    
      end

    end
    
  end
  
  def generateImplementations
    
    @nodes.each do |nodeIdentifier, node|
    
      node.protocols.each do |protocol|
        
        identifier = Class::generateIdentifierFromName(protocol)
        if identifier.length > 0 and @nodes.has_key?(identifier)
      
          @implementations[node.identifier].push(identifier)
      
        end
    
      end

    end
    
  end
  
  def generateInheritance
    
    @nodes.each do |nodeIdentifier, node|
    
      if (node.superclass)
    
        identifier = Class::generateIdentifierFromName(node.superclass)
        if @nodes.keys.include? identifier
      
          @inheritances[node.identifier] = identifier
      
        end
        
      end

    end
    
  end
  
  def preamble()
  
    return "digraph G {

    		fontname = \"Bitstream Vera Sans\"
    	    fontsize = 8

    	    node [
    			fontname = \"Bitstream Vera Sans\"
    			fontsize = 8
    			shape = \"record\"
    		]

    	    edge [
    			fontname = \"Bitstream Vera Sans\"
    	        fontsize = 8
    		]\n"
      
  end

  def postamble()
  
    return "}"
  
  end
  
  def graphItemForNode(node)
    
    classNameString = node.name
    if node.superclass and node.superclass.length > 0
      superclassIdentifier = Class::generateIdentifierFromName(node.superclass)
      if !@nodes.has_key?(superclassIdentifier)
        classNameString += " : " + node.superclass
      end  
    end
    
    classDiagramString = String.new
  
    classDiagramString = node.identifier + " [
    			label = \"{" + classNameString + " | "
      
      
    node.properties.each do |fullProperty|
      
      type = String.new
      name = String.new
      
      type = fullProperty.type.gsub("<", "\\<")
      type.gsub!(">", "\\>")
      type.strip!
      
      name = fullProperty.name.strip
      
      classDiagramString += type + " " + name + "\\l"
      
    end

    classDiagramString += "|"

    node.methods.each do |fullMethod|
      
      methodString = String.new
      methodString = fullMethod.gsub("<", "\\<")
      methodString.gsub!(">", "\\>")
      
      classDiagramString += methodString + "\\l"
      
    end

    classDiagramString += "}\"]\n"
    
    return classDiagramString
    
  end
  
  def graphAssociations
    
    associationsString = String.new
    
    @associations.each do |identifier, associatedIdentifiers|
      
      associatedIdentifiers.each do |associatedIdentifier|
      
        associationsString += identifier + " -> " + associatedIdentifier + "\n"
        
      end
      
    end
    
    if associationsString.length > 0
      associationsString = "edge [arrowhead = \"none\"] " + associationsString
    end
    
    associationsString += "\n"
    
    return associationsString
    
  end
  
  def graphInheritances
    
    inheritancesString = String.new
    
    @inheritances.each do |identifier, inheritanceIdentifier|

        inheritancesString += identifier + " -> " + inheritanceIdentifier + "\n"
      
    end
    
    if inheritancesString.length > 0
      inheritancesString = "edge [arrowhead = \"empty\"] " + inheritancesString
    end
    
    inheritancesString += "\n"
    
    return inheritancesString
    
  end
  
  def graphImplementations
    
    implementationsString = String.new
    implementationsString += "edge [style = \"dashed\", arrowhead = \"empty\"] "
    
    @implementations.each do |identifier, implementedIdentifiers|
      
      implementedIdentifiers.each do |implementedIdentifier|
      
        implementationsString += identifier + " -> " + implementedIdentifier + "\n"
        
      end
      
    end
    
    implementationsString += "\n"
    
    return implementationsString
    
  end
  
end