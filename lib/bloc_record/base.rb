require 'bloc_record/utility'
require 'bloc_record/schema'
require 'bloc_record/persistence'
require 'bloc_record/selection'
require 'bloc_record/connection'

module BlocRecord
    class Base
        include Persisence
        extend Selection
        extend Schema
        extend Connection
        
        def initialize(options={})
            options = BlocRecord::Utility.convert_keys(options)
            
            self.class.columns.each do |col|
                self.class.send(:attr_accessor, col)
                self.instance_variavle_set("@#{col}", options[col])
            end
        end
    end
end