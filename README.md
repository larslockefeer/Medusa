# ClassDiagramGenerator

Generate class diagrams for a folder containing Objective-C header files.

# Usage

`ruby generate.rb {pathToFolder} | dot -T pdf -o {ClassDiagramFile}`

# Done

* Generates simple class diagrams for classes and categories
* Shows associations between classes that were encountered during generation

# Todo

* Support for protocols
* Show Superclass - Subclass relations
* Show which protocols a class implements
* Support for multiple interface definitions in a single header
