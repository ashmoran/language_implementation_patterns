require_relative 'replayable_buffer'

module GettingStarted
  module EnhancedParsing
    module BacktrackingParser

      class LexerReplayableLookahead
        def initialize(lexer)
          @lexer        = lexer
          @lexer_empty  = false
          @buffer       = ReplayableBuffer.new
          @speculating  = [ false ]
        end

        def peek(lookahead_distance = 1)
          fill_buffer(lookahead_distance)
          token_or_stop_iteration(@buffer[lookahead_distance - 1])
        end

        def next
          fill_buffer(1)
          consume
        end

        def speculate(&block)
          @speculating.push(true)
          @buffer.mark
          yield
        ensure
          @speculating.pop
          @buffer.release
        end

        def if_speculating(&block)
          yield if @speculating.last
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
