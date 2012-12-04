shared_examples_for "a ListParser with parallel assignment" do
  describe "statements" do
    context "a list" do
      let(:token_descriptions) {
        [
          { lbrack: "[" },
            { name:   "a" }, { equals: "=" }, { name:   "b" }, { comma:  "," },
            { name:   "c" }, { comma:  "," },
            { name:   "d" },
          { rbrack: "]" },
          { eof:    nil }
        ]
      }

      specify {
        expect(parser.list).to be == [ { :a => :b }, :c, :d ]
      }
    end

    context "a parallel assignment" do
      let(:token_descriptions) {
        [
          { lbrack: "[" },
            { name:   "a" }, { comma:  "," }, { name:   "b" },
          { rbrack: "]" },
          { equals: "=" },
          { lbrack: "[" },
            { name:   "c" }, { comma:  "," }, { name:   "d" },
          { rbrack: "]" },
          { eof:    nil }
        ]
      }

      specify {
        expect(parser.stat).to be == { [ :a, :b ] => [ :c, :d ] }
      }
    end

    context "invalid statement" do
      # "[ a ] b"
      let(:token_descriptions) {
        [
          { lbrack: "[" },
          { name:   "a" },
          { rbrack: "]" },
          { name:   "b" },
          { eof:    nil }
        ]
      }

      specify {
        expect {
          parser.stat
        }.to raise_error(
          NoViableAlternativeError, "Expecting <list> or <parallel assignment>"
        )
      }
    end
  end
end