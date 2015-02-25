require 'rspec/expectations'

RSpec::Matchers.define :eq_time do |expected|
  match do |actual|
    actual.utc.to_i == expected.utc.to_i
  end

  failure_message do |actual|
    "expected that #{actual} would be a same time as #{expected}"
  end

  description do
    "time comparator"
  end
end