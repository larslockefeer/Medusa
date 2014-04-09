# ObjCFileParser.rb
# Parses an Objective-C file into a generic Class structure that our diagram generator
# knows how to deal with
#
# (c) 2014 - Lars Lockefeer

class ObjCFileParser
  
  def initialize(fileName)
    @fileName = fileName
  end
  
  def parse
    
    parsedClass = Class.new(getClassNameFromFile, getSuperClassFromFile, getProtocolsFromFile, getPropertiesFromFile, getMethodsFromFile)
    return parsedClass

  end
  
  private
  
  def getClassInfo
    
    classInfo = String.new
    classInfo = %x[grep '^@interface' '#{@fileName}']
    
    if (classInfo.length == 0)
      
      classInfo = %x[grep '^@protocol' '#{@fileName}']
      
    end
    
    classInfo.delete!("\n")
    
    return classInfo
    
  end
  
  def getClassNameFromFile
    
    # Check if it is a category or protocol
    className = %x[echo '#{getClassInfo}' | grep -oE '[a-zA-Z0-9]*\s[(][a-zA-Z0-9]\+[)]']
    className.delete!(" \n")
    
    if (className.length == 0)
    
      # Not a category, maybe a regular class
      className = %x[echo '#{getClassInfo}' | grep -oE '[a-zA-Z0-9]* [:]']
      className.delete!(" :\n")
      
    end
    
    if (className.length == 0)
      
      # Not a regular class as well, maybe a protocol
      className = %x[echo '#{getClassInfo}' | grep -oE '[a-zA-Z0-9]* [<|$]']
      className.delete!("<\n")
      
    end
  
    return className
    
  end
  
  def getSuperClassFromFile
    
    superClass = %x[echo '#{getClassInfo}' | grep -oE '[:]\s\?[a-zA-Z0-9]*\s\?']
    
    if superClass.length > 0
      
      superClass.delete!(" :\n")
      return superClass
      
    end
    
    return nil
    
  end
  
  def getProtocolsFromFile
    
    protocolList = Array.new
    
    protocols = %x[echo '#{getClassInfo}' | grep -o '<[a-zA-Z0-9\, ]*>']
    
    if protocols.length > 0
      
      protocols.gsub!("<", "")
      protocols.gsub!(">", "")
      
      protocols.split(",").each do |protocol|
        
        protocol.delete!(" \n")
        protocolList.push(protocol)
        
      end
      
    end
    
    return protocolList
    
  end
  
  def getPropertiesFromFile
    
    properties = %x[grep ^@property '#{@fileName}' | grep -oE '[a-zA-Z0-9_]*\s\?(<[a-zA-Z0-9]*>)?\s\?[*]\?\s\?[a-zA-Z0-9]*;']
    propertyList = properties.split(/\n/)
    
    allProperties = Array.new
    
    propertyList.each do |fullProperty|
    
      matchData = /([a-zA-Z0-9_]*\s?)?(<[a-zA-Z0-9]*>?|\*|\s)/.match(fullProperty)
      
      type = matchData.to_s
      name = fullProperty.gsub(type, "")
      if (/\*/.match(type))
        
        name = "*" + name
        type.gsub!("*", "")
        
      end
      
      allProperties.push(Property.new(type, name))
    
    end

    return allProperties
    
  end
  
  def getMethodsFromFile
    
    methods = %x[grep ^'[\-+]\s*\([a-zA-Z\s\*]*\)' '#{@fileName}']
    methodList = methods.split(/\n/)
    return methodList
    
  end
  
end