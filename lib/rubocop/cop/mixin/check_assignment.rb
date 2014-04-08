# encoding: utf-8

module Rubocop
  module Cop
    # Common functionality for checking assignment nodes.
    module CheckAssignment
      TYPES = Util::ASGN_NODES - [:casgn, :op_asgn]
      TYPES.each do |type|
        define_method("on_#{type}") do |node|
          _lhs, rhs = *node
          check_assignment(node, rhs)
        end
      end

      def on_casgn(node)
        _scope, _lhs, rhs = *node
        check_assignment(node, rhs)
      end

      def on_op_asgn(node)
        _lhs, _op, rhs = *node
        check_assignment(node, rhs)
      end

      ELEMENT_SETTERS = [:[]=]

      def on_send(node)
        _receiver, method_name = *node
        if ELEMENT_SETTERS.include?(method_name)
          _receiver, _setter, _key, rhs = *node
        elsif method_name.to_s.end_with?('=') # setter
          _receiver, _setter, rhs = *node
        else
          return
        end

        check_assignment(node, rhs)
      end
    end
  end
end
