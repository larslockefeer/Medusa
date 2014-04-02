# Global variables - This is a prototype

$classesSeen = Array.new

# Methods

def classNameToIdentifier(className)
  
  classIdentifier = String.new
  
  classIdentifier = className.delete(")")
  classIdentifier = classIdentifier.gsub("(", "_")
  
  return classIdentifier
  
end

def parseClassNameForFile(fileName)

  # className = %x[grep '^@interface' '#{fileName}' | grep -o -e '[a-zA-Z0-9]*\s[(][a-zA-Z0-9]\+[)]' -e '[a-zA-Z0-9]* [:]']
  
  # Check if it is a category
  className = %x[grep '^@interface' '#{fileName}' | grep -oE '[a-zA-Z0-9]*\s[(][a-zA-Z0-9]\+[)]']
  
  if (className.length == 0)
    
    # Not a category, maybe a regular class
    className = %x[grep '^@interface' '#{fileName}' | grep -oE '[a-zA-Z0-9]* [:]']
    
  end
  
  className.delete!(" :\n")
  
  return className

end

def parsePropertiesForFile(fileName)

  # properties = %x[grep ^@property '#{fileName}' | grep -oE '[a-zA-Z0-9_]*\s\?[*]\?\s\?[a-zA-Z0-9]*;']
  properties = %x[grep ^@property '#{fileName}' | grep -oE '[a-zA-Z0-9_]*\s\?(<[a-zA-Z0-9]*>)?\s\?[*]\?\s\?[a-zA-Z0-9]*;']
  propertyList = properties.split(/\n/)
  return propertyList
  
end

def parseMethodsForFile(fileName)
  
  methods = %x[grep ^'[\-+] \([a-zA-Z\s\*]*\)' '#{fileName}']
  methodList = methods.split(/\n/)
  return methodList
  
end

def classDiagramForFile(fileName)
  
  # Get class name
  className = parseClassNameForFile(fileName)
  
  if (className.length == 0)
    return ""
  end
  
  # Get list of properties
  propertyList = parsePropertiesForFile(fileName)

  # Get list of methods
  methodList = parseMethodsForFile(fileName)
  
  # Record that we've seen this class
  $classesSeen.push(className)

  # And generate the string
  classDiagramString = String.new
  
  classDiagramString = classNameToIdentifier(className) + " [
  			label = \"{" + className + " | "
      
  propertyList.each do |fullProperty|
    fullProperty = fullProperty.gsub("<", "\\<")
    fullProperty = fullProperty.gsub(">", "\\>")
    classDiagramString += fullProperty.strip + "\\l"
  end

  classDiagramString += "|"

  methodList.each do |fullMethod|
    fullMethod = fullMethod.gsub("<", "\\<")
    fullMethod = fullMethod.gsub(">", "\\>")
    classDiagramString += fullMethod + "\\l"
  end

  classDiagramString += "}\"]\n"
  
  return classDiagramString
  
end

def associationsForFile(fileName)
  
  # Get class name
  className = parseClassNameForFile(fileName)
  
  # Get list of properties
  propertyList = parsePropertiesForFile(fileName)
  
  classAssociationsString = String.new
  
  propertyList.each do |fullProperty|
    
    splitProperty = fullProperty.split(" ")
    type = splitProperty[0]    
    
    if $classesSeen.include? type
      
      classAssociationsString += classNameToIdentifier(className) + " -> " + type + "\n"
      
    end
    
  end
  
  return classAssociationsString
  
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

def classDiagramsForHeadersAtSearchPath(searchPath)
  
  allClassDiagramsString = String.new
  
  Dir.glob(searchPath + '/**/*.h') do |headerFile|
    allClassDiagramsString += classDiagramForFile(headerFile)
  end
  
  return allClassDiagramsString
  
end

def associationsForHeadersAtSearchPath(searchPath)
  
  allAssociationsString = String.new  
  
  allAssociationsString += "edge [arrowhead = \"none\"] "
  
  Dir.glob(searchPath + '/**/*.h') do |headerFile|
    allAssociationsString += associationsForFile(headerFile)
  end
  
  return allAssociationsString
  
end

def generateClassDiagrams(searchPath)
  return classDiagramsForHeadersAtSearchPath(searchPath)
end

def generateAssociations(searchPath)
  return associationsForHeadersAtSearchPath(searchPath)
end

# Get file name from command line
searchPath = ARGV[0]

puts preamble()
puts generateClassDiagrams(searchPath)
puts generateAssociations(searchPath)
puts postamble()