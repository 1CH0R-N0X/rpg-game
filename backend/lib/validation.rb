module Validation
  def self.require_fields(hash, *fields)
    missing = fields.select { |f| hash[f].nil? }
    if missing.any?
      return [false, "Missing required fields: #{missing.join(', ')}"]
    end
    [true, nil]
  end
end
