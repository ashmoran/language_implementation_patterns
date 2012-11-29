shared_examples_for "a ListParser with assignment" do
  context "list with assignment" do
    let(:token_descriptions) {
      [
        { lbrack: "[" },
        { name:   "a" },
        { equals: "=" },
        { name:   "b" },
        { rbrack: "]" },
        { eof:    nil }
      ]
    }

    specify {
      expect(parser.list).to be == [ { :a => :b } ]
    }
  end
end
