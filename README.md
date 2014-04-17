# Medusa

Generate class diagrams for a folder containing Objective-C header files.

# Requirements

* Ruby (tested with Ruby 2.0.0)
* Graphviz (tested with Graphviz 2.34.0)

# Usage

```
Generates a PDF class diagram from a set of source files
Usage: medusa INPUT_PATH OUTPUT_PATH [OPTIONS]

INPUT_PATH
     The path to the source files to parse
OUTPUT_PATH
     The path at which to put the generated diagram. The output will be a PDF file, so you'll want this to end in .pdf

Available options
    -p, --prune-orphans              Prune orphans from the diagram?
```

# Done

* Generates simple class diagrams for classes and categories
* Shows associations between classes that were encountered during generation
* Show Superclass <-> Subclass relations
* Shows which protocols a class implements, if the protocol was encountered during generation
* Has an option to prune orphans from the generated diagram

# Future feature ideas

* Use some (simple) templating system for the graph generation instead of the current implementation
* Add tests to ensure that the parser parses correctly
* Support for multiple interface definitions in a single header
* Add an option to supply a list to limit the classes included in the diagram
* Improve the parser
* Support for languages other than Objective-C
* Decide whether to also parse class extensions

# Disclaimer

This tool has been put together in a frenzy and was extended from a proof of concept that parsed header files from the command line using nothing but 'grep'. As a result the parser is hacked together and needs improvement. However, the current implementation works well enough to put this thing out in the wild.

Furthermore, this is my first encounter with Ruby which will most likely have some effect on the quality of the Ruby code ;-)
