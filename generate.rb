require './src/Model/Class'
require './src/Model/Property'
require './src/Model/Graph'
require './src/Parser/ObjCFileParser'

searchPath = ARGV[0]
graph = Graph.new

Dir.glob(searchPath + '/**/*.h') do |headerFile|  
  
  parser = ObjCFileParser.new(headerFile)
  parsedClass = parser.parse()
  
  graph.addNode(parsedClass)
  
end

puts graph.generate()
