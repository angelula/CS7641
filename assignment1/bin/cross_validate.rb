require_relative '../config/bootstrap'

class Analysis
  if ARGV.first.nil?
    ALGORITHMS = [KNearestNeighbor, SVM, J48Tree, AdaBoost, NeuralNetwork]
  else
    ALGORITHMS = [Kernel.const_get(ARGV.first)]
  end

  def initialize(file_hash, algorithm = nil)
    @files = file_hash.keys
    @instances = file_hash.map do |file, class_name|
      instances = CSVFile.load(file, class_name)
      instances
    end
  end

  def run_all!
    ALGORITHMS.each do |algo|
      @instances.each do |instance|
        puts "Running Analysis for #{instance.relation_name} #{algo}"
        run_algorithm!(algo, instance)
	algo.important_parts("./data/cross_validation/#{instance.relation_name}-#{algo.name.downcase}.yml")
      end
    end
  end

  def run_algorithm!(klass, instances)
    algorithm = klass.new(instances)
    cv = algorithm.map do |configured_algo|
      configured_algo.cross_validation
    end
    File.open("./data/cross_validation/#{instances.relation_name}-#{klass.name.downcase}.yml","wb") do |f|
      f.write(YAML::dump(cv))
    end
  end
end

wine = './data/wine_data/winequality.csv'
mushrooms = './data/mushrooms/agaricus-lepiota.csv'
analysis = Analysis.new({
  wine => 'red',
  mushrooms => 'class'
})

analysis.run_all!
