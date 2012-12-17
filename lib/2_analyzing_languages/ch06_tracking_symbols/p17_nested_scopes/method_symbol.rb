require_relative 'symbol_table'

module AnalyzingLanguages
  module TrackingSymbols
    module NestedScopes
      class MethodSymbol
        include Scope

        attr_reader :name, :type

        def initialize(name, type)
          @name = name.to_sym
          @type = type

          @symbols = { } # Hackety hackety hack
        end

        def ==(other)
          other.is_a?(MethodSymbol) &&
            @name == other.name &&
            @type == other.type
        end

        def wrap(parent_scope)
          @parent_scope = parent_scope
        end

        def to_s
          "method<#{@name}:#{@type}>"
        end
      end
    end
  end
end