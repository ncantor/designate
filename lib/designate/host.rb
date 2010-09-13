module Designate
  class Host < Client

    def initialize(data)
      data.each do |key, value|
        instance_variable_set("@#{key}", value)
        Host.instance_eval do
          attr_reader key.to_sym
        end
      end
    end

    def update(options = {})
      put("hosts/#{id}.xml", { :host => options })
    end

    def destroy
      delete("hosts/#{id}.xml")
    end

  end
end