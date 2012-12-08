guard 'cucumber', cli: "-p guard" do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$}) { 'features' }
  watch(%r{^features/step_definitions/.+$}) { 'features' }
end

guard 'rspec', cli: "--color --format Fuubar" do
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^spec/.+_contract\.rb})  { "spec" }
  watch(%r{^lib/(.+)\.rb})          { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')      { "spec" }
  watch(%r{spec/support/.+\.rb})    { "spec" }

  watch(%r{^lib/2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/cymbol_monolithic.treetop}) {
    "spec/2_analyzing_languages/ch06_tracking_symbols/p16_monolithic_scope/cymbol_spec.rb"
  }

  watch(%r{^lib/2_analyzing_languages/ch06_tracking_symbols/p17_nested_scopes/cymbol_nested.treetop}) {
    "spec/2_analyzing_languages/ch06_tracking_symbols/p17_nested_scopes/cymbol2_parser_spec.rb"
  }
end
