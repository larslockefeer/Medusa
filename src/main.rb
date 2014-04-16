require './src/Model/Class'
require './src/Model/Property'
require './src/Model/Graph'
require './src/Parser/ObjCFileParser'

class Medusa
  def initialize(input_path, output_path, options)
      
    @options = options
    @input_path = input_path
    @output_path = output_path
      
  end

  def run
    
    graph = Graph.new(@options)
    Dir.glob(@input_path + '/**/*.h') do |headerFile|  
  
      parser = ObjCFileParser.new(headerFile)
      parsedClass = parser.parse()
  
      graph.addNode(parsedClass)
  
    end

   %x[echo '#{graph.generate()}' | dot -T pdf -o #{@output_path}]
        
  end
end