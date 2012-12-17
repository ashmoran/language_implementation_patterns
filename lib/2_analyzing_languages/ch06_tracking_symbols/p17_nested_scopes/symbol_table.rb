module AnalyzingLanguages
  module TrackingSymbols
    module NestedScopes
      module Scope
        def define(symbol)
          @symbols[symbol.name] = symbol
        end

        def resolve(name)
          @symbols.fetch(name.to_sym) {
            @parent_scope.resolve(name)
          }
        end

        def unwrap
          @parent_scope
        end
      end

      class SymbolTable
        class DeadEndScope
          def resolve(name)
            raise "Unknown symbol: #{name}"
          end
        end

        class LocalScope
          include Scope

          def initialize(parent_scope = :remove_me)
            @parent_scope = parent_scope
            @symbols = { }
          end


          def to_s
            "symbols: {#{key_value_pairs.join(", ")}}"
          end

          private

          def key_value_pairs
            @symbols.keys.sort.map { |key| "#{key}=#{@symbols[key]}" }
          end
        end

        def initialize
          @scope = LocalScope.new(DeadEndScope.new)
        end

        def push_scope
          @scope = LocalScope.new(@scope)
        end

        def pop_scope
          @scope = @scope.unwrap
        end

        def define(symbol, metadata = { })
          @scope.define(symbol)
        end

        def define_as_scope(symbol, metadata = { })
          define(symbol)
          symbol.wrap(@scope)
          @scope = symbol
        end

        def resolve(name, metadata = { })
          @scope.resolve(name)
        end

        def to_s
          @scope.to_s
        end
      end

    end
  end
end