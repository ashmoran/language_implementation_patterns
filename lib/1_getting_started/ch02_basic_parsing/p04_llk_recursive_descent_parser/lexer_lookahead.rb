module GettingStarted
  module BasicParsing
    module LLkRecursiveDescentParser

      # Helps implement Pattern 4: LL(k) Recursive-Descent Parser
      #
      # Major differences from the book example:
      #
      # * This isn't actually LL(k) because there isn't a fixed size _k_ for
      #   the lookahead buffer (the book example uses a small circular buffer).
      #   It's so easy to implement this by shifting a Ruby Array I went with
      #   the idiomatic solution rather than the memory-efficient one. I'm not
      #   too bothered about this from a learning point of view because I only
      #   care about what this does, not how to implement it efficiently.
      #
      # * This solution uses a separate object rather than rolling the lookahead
      #   code into the Parser. The code below could be used to add lookahead to
      #   any lexer, and can feed any parser, even a non-lookahead one (it
      #   conforms to the ListLexer contract).
      class LexerLookahead
        def initialize(lexer)
          @lexer        = lexer
          @lexer_empty  = false
          @buffer       = [ ]
        end

        def peek(lookahead_distance = 1)
          fill_buffer(lookahead_distance)
          token_or_stop_iteration(@buffer[lookahead_distance - 1])
        end

        def next
          fill_buffer(1)
          consume
        end

        private

        def consume
          token_or_stop_iteration(@buffer.shift)
        end

        def fill_buffer(required_size)
          (required_size - @buffer.size).times do
            harvest
          end
        end

        def harvest
          @buffer << @lexer.next
        rescue StopIteration
          def self.harvest
            # NOOP
          end

          def self.token_or_stop_iteration(token)
            raise StopIteration if token.nil?
            token
          end
        end

        def token_or_stop_iteration(token)
          token
        end
      end
    end
  end
end