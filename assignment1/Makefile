all: charts latex zip ;
	echo 'Finished build'
run:
	jruby bin/cross_validate.rb
charts:
	mkdir -p assets
	R < ./lib/charts.r --vanilla
	jruby bin/j48_dot.rb
	dot -Tpng ./assets/winequality.dot > ./assets/winequality_tree.png
	dot -Tpng ./assets/agaricus-lepiota.dot  > ./assets/mushroom_tree.png
latex:
	pdflatex langelucci6-analysis.latex
