install.packages("scatterplot3d", repos="http://R-Forge.R-project.org")

To be able to run this code you will need JRuby which is easily downloaded via

http://www.jruby.org/download

On top of JRuby I have attached all of the R code that created the graphics and a Makefile that helps make different things.

On top of that I included in a module called CrossValidation that will run by default a 10 fold cross validation and return a hash. When I ran the analysis I used bin/cross_validation.rb to run all of them.

J48Tree has the added method of save_graph! which will save the .dot file created from the tree.

To do the graphing I used R since it's the easiest to use and to make all of the charts just run "make charts".
