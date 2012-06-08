AttributeNormalizer.configure do |config|
  config.normalizers[:as_array_of_integer] = ->(value, options) do
    value.reject { |e| e.blank? }.map(&:to_i)
  end
end
