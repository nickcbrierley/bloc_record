require 'bloc_record/utility'
require 'bloc_record/schema'
require 'bloc_record/persistence'
require 'bloc_record/selection'
require 'bloc_record/connection'
require 'bloc_record/collection'

module BlocRecord
    class Base
        include Persistence
        extend Selection
        extend Schema
        extend Connection
        
        def initialize(options={})
            options = BlocRecord::Utility.convert_keys(options)
            
            self.class.columns.each do |col|
                self.class.send(:attr_accessor, col)
                self.instance_variable_set("@#{col}", options[col])
            end
        end
        
        def method_missing(method, *args, &block)
            if method.include? "update"
                m = method[methid,index("_")+1..-1]
            end
            update_attribute(m, arg[0])
        end
    end
end