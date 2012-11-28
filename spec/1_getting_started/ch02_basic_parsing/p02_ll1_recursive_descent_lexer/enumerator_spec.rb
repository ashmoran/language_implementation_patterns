require 'spec_helper'

require_relative 'enumerator_contract'

# Prove that the Enumerator interface we depend on works how we think it does
describe "a real Enumerator" do
  subject(:array_enumerator) { [ { eof: nil } ].each }

  def advance_to_end
    array_enumerator.next
  end

  it_behaves_like "an Enumerator"
end