java_import 'weka.classifiers.lazy.IBk'
java_import 'weka.core.ManhattanDistance'
java_import 'weka.core.EuclideanDistance'
java_import 'weka.core.neighboursearch.LinearNNSearch'
java_import 'weka.core.neighboursearch.KDTree'
require 'csv'

class KNearestNeighbor
  include CrossValidation
  extend Forwardable
  include Enumerable

  def_delegators :@classifier,
    :knn=

  def initialize(instances)
    @classifier = IBk.new
    @instances = instances
  end

  def distance_function=(dist_funct)
    @distance_function = dist_funct
    search = LinearNNSearch.new

    if dist_funct == :euclidean
      search.distance_function = EuclideanDistance.new
    elsif dist_funct == :manhattan
      search.distance_function = ManhattanDistance.new
    else
      throw 'Wrong distance function'
    end

    @classifier.nearest_neighbour_search_algorithm
  end

  def summary_data
    {:knn => @classifier.knn, :distance_function => @distance_function}
  end

  def each(&block)
    [:euclidean, :manhattan].each do |distance_fun|
      1.step(50, 2).each do |k|
        knn = KNearestNeighbor.new(@instances)
        knn.knn = k
        knn.distance_function = distance_fun

        yield knn
      end
    end
  end

  def self.important_parts(cross_validation_data)
    yml = YAML::load_file(cross_validation_data)
    knn = {}

    yml.each do |cv|
      k = cv.fetch(:knn)
      knn[k] ||= []
      knn[k] << cv
    end

    CSV.open("./data/supporting/#{File.basename(cross_validation_data, '.yml')}.csv", 'wb') do |csv|
      csv << %w[k euclidean manhattan]
      knn.each do |k, vs|
        array = vs.dup.sort_by {|v| v.fetch(:distance_function).to_s }
        row = [k]
        array.each {|a| row << a.fetch(:root_mean_squared_error) }
        csv << row
      end
    end
  end
end
