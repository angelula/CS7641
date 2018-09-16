java_import 'weka.classifiers.Evaluation'
java_import 'weka.classifiers.Classifier'
java_import 'weka.core.Utils'

module CrossValidation
  def build!
    @classifier.build_classifier(@instances)
  end

  def cross_validation
    @folds ||= 20
    evaluation = Evaluation.new(@instances)

    puts "Evaluating:\n #{summary_data.to_yaml}"

    (1..@folds).each do |fold|
      training = @instances.train_cv(@folds, fold - 1)
      testing = @instances.test_cv(@folds, fold - 1)

      classifier_copy = @classifier.dup
      classifier_copy.build_classifier(training)
      puts "Fold: #{fold}"
      evaluation.evaluate_model(classifier_copy, testing)
    end

    confusion_matrix = evaluation.confusion_matrix.map do |row|
      row.to_a
    end

    output = {
      :dataset => @instances.relation_name,
      :folds => @folds,
      # :summary_string => evaluation.to_summary_string("=== #{@folds}-fold Cross-validation ===", false),
      :total_num_instances => @instances.num_instances,
      :root_relative_squared_error => evaluation.root_relative_squared_error,
      :relative_absolute_error => evaluation.relative_absolute_error,
      :root_mean_squared_error => evaluation.root_mean_squared_error,
      :mean_absolute_error => evaluation.mean_absolute_error,
      :kappa_statistic => evaluation.kappa,
      :false_positives => evaluation.num_false_positives(@instances.class_index),
      :false_negatives => evaluation.num_false_negatives(@instances.class_index),
      :confusion_matrix => confusion_matrix
    }

    output = output.merge(self.summary_data)

    output
  end
end