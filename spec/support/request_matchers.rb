# From http://stackoverflow.com/a/15463638/687420
RSpec::Matchers.define :have_submit_button do |value|
  match do |actual|
    actual.should have_selector("input[type=submit][value='#{value}']")
  end
end
