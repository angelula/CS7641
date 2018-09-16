java_import 'weka.classifiers.meta.AdaBoostM1'
require 'csv'
class AdaBoost
  include CrossValidation
  extend Forwardable
  include Enumerable

  def_delegators :@classifier,
    :num_iterations=,
    :use_resampling=,
    :weight_threshold=

  def initialize(instances)
    @classifier = AdaBoostM1.new
    @instances = instances
  end

  def summary_data
    Hash[%w[weight_threshold use_resampling num_iterations].map do |k|
      [k, @classifier.send(k)]
    end]
  end

  def each(&block)
    [10, 100, 500, 1000, 5000, 10000].each do |iterations|
      adaboost = AdaBoost.new(@instances)
      adaboost.num_iterations = iterations

      yield adaboost
    end
  end

  def self.important_parts(cross_validation_data)
    yml = YAML::load_file(cross_validation_data)

    CSV.open("./data/supporting/#{File.basename(cross_validation_data, '.yml')}.csv", 'wb') do |csv|
      csv << %w[iterations root_mean_squared_error]

      yml.each do |cv|
        csv << [cv.fetch('num_iterations'), cv.fetch(:root_mean_squared_error)]
      end
    end
  end
end
