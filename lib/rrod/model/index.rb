module Rrod
  module Model
    class Index
   
      attr_accessor :attr
   
      def initialize(attr, name = nil)
        @attr = attr
        @name = name || attr.name 
      end

      def name
        "#{@name}_#{type}"
      end   
 
      def type
        attr.type == String ? "bin" : "int"
      end
     
      def cast(model)
        meth = type == "bin" ? :to_s : :to_i
        model.send(@attr.name).send(meth)
      end

    end
  end
end
