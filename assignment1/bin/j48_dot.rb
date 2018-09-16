require_relative '../config/bootstrap'

mushrooms = './data/mushrooms/agaricus-lepiota.csv'
wine = './data/wine_data/winequality.csv'

mush = J48Tree.new(CSVFile.load(mushrooms, 'class'))
mush.min_num_obj = 2
mush.confidence_factor = 0.25
mush.build!
mush.save_graph!

wine = J48Tree.new(CSVFile.load(wine, 'above_average'))
wine.min_num_obj = 5
wine.confidence_factor = 0.05
wine.build!
wine.save_graph!
