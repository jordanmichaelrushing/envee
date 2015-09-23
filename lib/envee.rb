require 'envee/version'
require 'time'

# Adds casting fetchers and validation for values filled with a placeholder.
module Envee
  # Error thrown by validate when there are missing keys
  class MissingValuesError < StandardError
    def initialize(missing_keys)
      super(
        "The following environment variables are not set, but should be:\n"\
        "#{missing_keys.join("\n")}\n"
      )
    end
  end

  def int(*args, &block)
    Integer(fetch(*args, &block))
  end

  def fl(*args, &block)
    Float(fetch(*args, &block))
  end

  def str(*args, &block)
    String(fetch(*args, &block))
  end

  def sym(*args, &block)
    String(fetch(*args, &block)).to_sym
  end

  def bool(*args, &block)
    value = fetch(*args, &block)

    value && value !~ /\A(0|no|false|off|nil|null|)\z/i
  end

  def time(*args, &block)
    value = fetch(*args, &block)
    return value if value.is_a?(Time)
    Time.parse(value).utc
  end

  def int_time(*args, &block)
    value = Integer(fetch(*args, &block))
    return value if value.is_a?(Time)
    Time.at(value).utc
  end

  def validate!(options)
    missing = options[:placeholder] || 'CHANGEME'
    missing_keys = select{|_k, v| v.include?(missing)}.map(&:first)
    raise MissingValuesError, missing_keys unless missing_keys.empty?
  end
end

ENV.extend(Envee)
