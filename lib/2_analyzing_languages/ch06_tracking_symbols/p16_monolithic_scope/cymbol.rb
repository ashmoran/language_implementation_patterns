require 'treetop'

module AnalyzingLanguages; module TrackingSymbols; module MonolithicScope; end; end; end
Treetop.load(File.dirname(__FILE__) + '/cymbol_monolithic')

require_relative 'cymbol_monolithic_node_classes'

module AnalyzingLanguages
  module TrackingSymbols
    module MonolithicScope

      # Implements Pattern 16: Symbol Table for Monolithic Scope
      #
      # Note that this is more of an experimental playground than a translation
      # of the example in the book. Key points:
      #
      # * I'm using Treetop, not ANTLR. Mainly because I wanted to learn an
      #   implementation of Parsing Expression Grammars (mentioned on p56),
      #   and because Treetop works well in all Ruby runtimes, whereas ANTLR
      #   needs JRuby if you want access to the latest version. (The Ruby
      #   target lags behind the Java, C, C++ targets etc.)
      #
      # * The book produces output with code blocks in the ANTLR grammar.
      #   I wanted to avoid hijacking the predicate system in Treetop, so the
      #   way I solve it is closer to Pattern 25: Tree-Based Interpreter. Note
      #   that it's not a very *good* interpreter, but it does the job of
      #   spitting out the output we want (or something close enough to it).
      class Cymbol
        def initialize(symbol_table)
          @symbol_table = symbol_table
          @parser = CymbolMonolithicParser.new
        end

        def parse(source)
          populate_symbols(tree(source))
        end

        private

        def tree(source)
          @parser.parse(source)
        end

        def populate_symbols(tree)
          tree.populate_symbols(@symbol_table)
        end
      end

    end
  end
end