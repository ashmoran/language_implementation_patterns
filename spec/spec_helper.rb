require 'ap'

require 'fakefs/spec_helpers'
require 'lstrip-on-steroids'

RSpec.configure do |config|
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true
end
