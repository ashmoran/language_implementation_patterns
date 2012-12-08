require 'treetop'

module AnalyzingLanguages; module TrackingSymbols; module MonolithicScope; end; end; end
Treetop.load(File.dirname(__FILE__) + '/cymbol_monolithic')

require_relative 'variable_symbol'

module AnalyzingLanguages
  module TrackingSymbols
    module MonolithicScope

      # Module for Treetop
      module CymbolMonolithic
        class ::Treetop::Runtime::SyntaxNode
          def populate_symbols(symbol_table)
            return unless elements
            elements.each do |element|
              element.populate_symbols(symbol_table)
            end
          end

          private

          def location
            "line #{input.line_of(interval.first)}"
          end
        end

        class VarDeclaration < Treetop::Runtime::SyntaxNode
          def populate_symbols(symbol_table)
            var_type = symbol_table.resolve(type.name, location: location)
            if assignment
              assignment.populate_symbols(symbol_table)
            end
            symbol_table.define(VariableSymbol.new(var_name.name, var_type), location: location)
          end
        end

        class VarExpression < Treetop::Runtime::SyntaxNode
          def populate_symbols(symbol_table)
            symbol_table.resolve(type.name, location: location)
          end
        end

        class CymbolSymbol < Treetop::Runtime::SyntaxNode
          def name
            text_value
          end

          def populate_symbols(symbol_table)
            symbol_table.resolve(name, location: location)
          end
        end
      end

    end
  end
end