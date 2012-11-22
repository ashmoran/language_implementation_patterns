guard 'cucumber', cli: "-p guard" do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$}) { 'features' }
  watch(%r{^features/step_definitions/.+$}) { 'features' }
end

guard 'rspec', cli: "--color --format Fuubar" do
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^lib/(.+)\.rb})        { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')    { "spec" }
  watch(%r{spec/support/.+\.rb})  { "spec" }
end
