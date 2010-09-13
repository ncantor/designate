module Designate
  class Template < Client

    def initialize(data)
      data.each do |key, value|
        instance_variable_set("@#{key}", value)
        Template.instance_eval do
          attr_reader key.to_sym
        end
      end
    end

  end
end