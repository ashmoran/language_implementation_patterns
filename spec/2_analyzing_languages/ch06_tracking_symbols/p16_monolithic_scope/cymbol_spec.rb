require 'spec_helper'

require '2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/cymbol'

module AnalyzingLanguages
  module TrackingSymbols
    module MonolithicScope
      describe Cymbol do
        subject(:cymbol) { Cymbol.new }

        let(:input) {
          -%{
            int i = 9;
            float j;
            int k = i+2;
          }
        }

        let(:output_io) { StringIO.new }
        let(:output) { output_io.rewind; output_io.read.chomp }

        specify {
          cymbol.parse(input, log_to: output_io)
          expect(output.to_s).to be == -%{
            line 1: ref int
            line 1: def i
            line 2: ref float
            line 2: def j
            line 3: ref int
            line 3: ref to <i:int>
            line 4: def k
            globals = {int=int, j=<j:float>, k=<k:int>, float=float, i=<i:int>}
          }
        }
      end
    end
  end
end