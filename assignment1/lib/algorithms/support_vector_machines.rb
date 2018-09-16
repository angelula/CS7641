java_import 'weka.classifiers.functions.LibSVM'
java_import 'weka.core.SelectedTag'
require 'csv'

class SVM
  include CrossValidation
  extend Forwardable
  include Enumerable

  def_delegators :@classifier,
    :cost=,
    :degree=

  def initialize(instances)
    @classifier = LibSVM.new
    @classifier.cache_size = 100
    @classifier.shrinking = false
    @instances = instances
  end

  def kernel=(kernel)
    @kernel = kernel
    kernel_code = {
      :linear => LibSVM::KERNELTYPE_LINEAR,
      :polynomial => LibSVM::KERNELTYPE_POLYNOMIAL,
      :rbf => LibSVM::KERNELTYPE_RBF,
      :sigmoid => LibSVM::KERNELTYPE_SIGMOID
    }.fetch(kernel)

    tag = SelectedTag.new(kernel_code, LibSVM::TAGS_KERNELTYPE)
    @classifier.kernel_type = tag
  end

  def summary_data
    {:degree => @classifier.degree, :cost => @classifier.cost, :kernel => @kernel}
  end

  def each(&block)
    [:rbf].each do |kernel|
      -7.step(7, 3).each do |c_exp|
        svm = SVM.new(@instances)
        svm.kernel = kernel
        svm.cost = 2 ** c_exp
        yield svm
      end
    end
  end

  def self.important_parts(cross_validation_data)
    yml = YAML::load_file(cross_validation_data)

    CSV.open("./data/supporting/#{File.basename(cross_validation_data, '.yml')}.csv", 'wb') do |csv|
      csv << %w[kernel C degree rmse]
      yml.each do |cv|
        csv << [
          cv.fetch(:kernel),
          cv.fetch(:cost),
          cv.fetch(:degree),
          cv.fetch(:root_mean_squared_error)
        ]
      end
    end
  end
end
