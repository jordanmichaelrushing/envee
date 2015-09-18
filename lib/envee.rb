require 'envee/version'
require 'time'

module Envee
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

  def str(*args, &block)
    String(fetch(*args, &block))
  end

  def bool(*args, &block)
    value = fetch(*args, &block)

    value && value !~ /^(0|no|false|off|)$/i
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
    missing = options[:missing_value]
    missing_keys = select{|k, v| v.include?(missing)}.map(&:first)
    raise MissingValuesError.new(missing_keys) unless missing_keys.empty?
  end
end

ENV.extend(Envee)
