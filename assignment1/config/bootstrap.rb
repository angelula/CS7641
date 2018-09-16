require 'java'
require 'yaml'
require 'forwardable'

require_relative '../vendor/libsvm.jar'
require_relative '../vendor/weka.jar'

Dir['./lib/**/*.rb'].each {|r| require r }

def file
  Dir['./data/**/*.csv'].last
end

def class_name
  'class'
end
