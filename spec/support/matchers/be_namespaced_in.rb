RSpec::Matchers.define :be_namespaced_in do |module_name|
  match do |actual|
    actual.to_s =~ %r{\A#{module_name}::[^:]*\Z}
  end

  description do
    "be namespaced within #{module_name}"
  end
end