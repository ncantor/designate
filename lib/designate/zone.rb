module Designate
  class Zone < Client

    def initialize(data)
      data.each do |key, value|
        instance_variable_set("@#{key}", value)
        Zone.instance_eval do
          attr_reader key.to_sym
        end
      end
      hosts = []
      data['hosts'].each { |host| hosts << Host.new(host) }
      @hosts = hosts
    end

    def update(options = {})
      options[:default_ttl] ||= 14400
      options[:nx_ttl] ||= 900
      if options[:zone_template_id]
        options[:follow_template] ||= 'no'
      end
      put("zones/#{id}.xml", { :zone => options })
    end

    def destroy
      delete("zones/#{id}.xml")
    end

    def host(host_id)
      if host = get("hosts/#{host_id}.xml")['host']
        Host.new(host)
      end
    end

    def create_host(host_type, data, options = {})
      raise InvalidHostType unless %w(A AAAA CNAME MX NS SRV TXT).include?(host_type)
      options[:host_type] = host_type
      options[:hostname] ||= nil
      options[:data] = data
      if host = post("zones/#{id}/hosts.xml", { :host => options })
        return Host.new(host)
      end
    end

  end
end