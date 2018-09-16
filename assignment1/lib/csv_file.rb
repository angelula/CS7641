module CSVFile
  extend self

  def load(csv_path, class_name)
    loader = Java::WekaCoreConverters::CSVLoader.new
    loader.source = java.io.File.new(csv_path)
    data = loader.data_set
    data.class = data.enumerate_attributes.detect {|a| a.name == class_name}
    data
  end
end