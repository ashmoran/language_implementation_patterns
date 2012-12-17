require 'treetop'

require_relative 'method_symbol'
require_relative '../p16_monolithic_scope/variable_symbol'

module AnalyzingLanguages; module TrackingSymbols; module NestedScopes; end; end; end
Treetop.load(File.dirname(__FILE__) + '/cymbol_nested')

module AnalyzingLanguages
  module TrackingSymbols
    module NestedScopes

      # Module for Treetop
      module CymbolNested
        class ::Treetop::Runtime::SyntaxNode
          def walk(symbol_table)
            return unless elements
            elements.each do |element|
              element.walk(symbol_table)
            end
          end

          private

          def location
            "line #{input.line_of(interval.first)}"
          end
        end

        class MethodDefinition < Treetop::Runtime::SyntaxNode
          def walk(symbol_table)
            method_type = symbol_table.resolve(type.name, location: location)
            symbol_table.define_as_scope(MethodSymbol.new(name.name, method_type), location: location)

            parameters.each do |parameter|
              parameter_type = symbol_table.resolve(parameter.type.name, location: location)
              symbol_table.define(
                MonolithicScope::VariableSymbol.new(parameter.name.name, parameter_type),
                location: location
              )
            end

            body.walk(symbol_table)
          end
        end

        class CymbolBlock < Treetop::Runtime::SyntaxNode
          def walk(symbol_table)
            symbol_table.push_scope
            elements.each do |element|
              element.walk(symbol_table)
            end
          end
        end

        class ParameterList < Treetop::Runtime::SyntaxNode
          def each(&block)
            parameters.each(&block)
          end

          # We can only handle one - as it happens the book example only uses one
          def parameters
            [ first_parameter ]
          end
        end

        class VarDeclaration < Treetop::Runtime::SyntaxNode
          def walk(symbol_table)
            var_type = symbol_table.resolve(type.name, location: location)
            if initialization
              initialization.walk(symbol_table)
            end
            symbol_table.define(
              MonolithicScope::VariableSymbol.new(var_name.name, var_type),
              location: location
            )
          end
        end

        class CymbolSymbol < Treetop::Runtime::SyntaxNode
          def name
            text_value
          end

          def walk(symbol_table)
            symbol_table.resolve(name, location: location)
          end
        end
      end

    end
  end
end