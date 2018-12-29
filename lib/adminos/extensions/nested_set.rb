module CollectiveIdea #:nodoc:
  module Acts #:nodoc:
    module NestedSet #:nodoc:
      module Model
        module ClassMethods
          def arrange
            depth     = 0
            arranged  = ActiveSupport::OrderedHash.new
            insertion = [arranged]

            each_with_level(order(quoted_order_column_full_name)) do |node, level|
              next if level > depth && insertion.last.keys.last &&
                node.parent_id != insertion.last.keys.last.id

              insertion.push insertion.last.values.last if level > depth
              (depth - level).times { insertion.pop } if level < depth
              insertion.last.merge! node => ActiveSupport::OrderedHash.new
              depth = level
            end

            arranged
          end
        end # end class methods
      end
    end
  end
end
