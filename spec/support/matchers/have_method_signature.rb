RSpec::Matchers.define :have_method_signature do |method_name,expected|
  match do |actual|
    normalized_method_name = method_name.to_s.sub(/^[\.\#]/,'').to_sym
    case method_name.to_s
    when /^\./
      actual.method(normalized_method_name).arity == expected
    when /^\#/
      actual.instance_method(normalized_method_name).arity == expected
    else
      actual.method(normalized_method_name).arity == expected
    end
  end

  description do
    "define #{method_name} [arity:#{expected}]"
  end
end