module DataMapper
  module ActiveRecordMethods
    def self.included(model)
      model.class_eval do
        extend  ClassMethods
        include InstanceMethods
      end
    end

    class RecordNotSaved < DataMapper::PersistenceError; end

    module InstanceMethods
      def logger
        self.class.logger
      end

      def bang(&block)
        block.call or raise RecordNotSaved
        return self
      end
      
      def update_attributes!(hash)
        bang{update_attributes(hash)}
      end
    end

    module ClassMethods
      def logger
        DataMapper.logger
      end

      def create!(attributes)
        new(attributes).bang{save}
      end
    end
  end
end
