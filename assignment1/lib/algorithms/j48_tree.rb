java_import 'weka.classifiers.trees.J48'
require 'forwardable'
require 'csv'
class J48Tree
  include CrossValidation
  extend Forwardable
  include Enumerable

  def_delegators :@classifier,
    :confidence_factor=,
    :binary_splits=,
    :min_num_obj=,
    :reduced_error_pruning=,
    :confidence_factor=,
    :graph

  def initialize(instances)
    @instances = instances
    @classifier = J48.new
  end

  def summary_data
    Hash[%w[confidence_factor use_laplace reduced_error_pruning min_num_obj binary_splits].map do |attribute|
      [attribute, @classifier.send(attribute)]
    end]
  end

  def save_graph!
    File.open("./assets/#{@instances.relation_name}.dot", "wb") { |f| f.write(graph) }
  end

  def self.important_parts(cross_validation_data)
    yml = YAML::load_file(cross_validation_data)

    CSV.open("./data/supporting/#{File.basename(cross_validation_data, '.yml')}.csv", 'wb') do |csv|
      csv << %w[min_num_obj confidence_factor root_mean_squared_error]

      yml.each do |cv|
        next if cv.fetch('binary_splits')
        csv << [
          cv.fetch('min_num_obj'),
          cv.fetch('confidence_factor'),
          cv.fetch(:root_mean_squared_error)
        ]
      end
    end
  end

  # Grid Search of best tree
  # 32 Different parameters
  def each(&block)
    0.05.step(0.45, 0.1).each do |confidence_factor|
      (2..5).each do |min_num_obj|
        tree = J48Tree.new(@instances)
        tree.min_num_obj = min_num_obj
        tree.confidence_factor = confidence_factor

        yield tree
      end
    end
  end
end
