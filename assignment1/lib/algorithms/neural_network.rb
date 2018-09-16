java_import 'weka.classifiers.functions.MultilayerPerceptron'
require 'csv'

class NeuralNetwork
  include CrossValidation
  extend Forwardable
  include Enumerable

  def_delegators :@classifier,
    :training_time=

  def initialize(instances)
    @classifier = MultilayerPerceptron.new
    @folds = 5
    @instances = instances
  end

  def summary_data
    {
      :training_time => @classifier.training_time
    }
  end

  def each(&block)
    100.step(500, 100).each do |training_time|
      ann = NeuralNetwork.new(@instances)
      ann.training_time = training_time

      yield ann
    end
  end

  def self.important_parts(cross_validation_data)
    yml = YAML::load_file(cross_validation_data)

    CSV.open("./data/supporting/#{File.basename(cross_validation_data, '.yml')}.csv", 'wb') do |csv|
      csv << %w[epochs rmse]

      yml.each do |cv|
        csv << [cv.fetch(:training_time), cv.fetch(:root_mean_squared_error)]
      end
    end
  end
end
