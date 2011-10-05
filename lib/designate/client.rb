require 'cgi'
module Designate

  class Client

    API_VERSION = "1.1"
    DOMAIN = "ns.zerigo.com"

    def initialize()
      @@auth_string = CGI.escape(zerigo_config[:username]) + ':' + CGI.escape(zerigo_config[:key])
      @domain = zerigo_config[:domain]
    end
    
    def zerigo_config()
      YAML.load(File.new("config/zerigo.yml"))
    end
    
    def zones
      zones = []
      get('zones.xml')['zones'].each { |zone| zones << Zone.new(zone) }
      return zones
    end

    def find_zone_by_id(id)
      if zone = get("zones/#{id}.xml")['zone']
        Zone.new(zone)
      end
    end

    def find_zone_by_domain(domain = @domain)
      if zone = get("zones/#{domain}.xml")['zone']
        Zone.new(zone)
      end
    end

    def create_zone(domain = @domain, options = {})
      options[:domain] = domain
      options[:default_ttl] ||= 14400
      options[:nx_ttl] ||= 300
      if options[:zone_template_id]
        options[:follow_template] ||= 'no'
      end
      if zone = post("zones.xml", { :zone => options })['zone']
        Zone.new(zone)
      end
    end

    def find_or_create_zone(domain = @domain)
      if zone = find_zone_by_domain(domain)
        return zone
      else
        create_zone(domain)
      end
    end

    def templates
      templates = []
      get('zone_templates.xml')['zone_templates'].each { |template| templates << Template.new(template) }
      return templates
    end

    def find_template_by_id(id)
      if template = get("zone_templates/#{id}.xml")['zone_template']
        Template.new(template)
      end
    end

    private

    def get(path)
      Crack::XML.parse(RestClient.get(url(path)))
    end

    def post(path, params = {})
      Crack::XML.parse(RestClient.post(url(path), params))
    end

    def put(path, params = {})
      Crack::XML.parse(RestClient.put(url(path), params))
    end

    def delete(path)
      Crack::XML.parse(RestClient.delete(url(path)))
    end

    def url(path)
      "https://#{@@auth_string}@#{DOMAIN}/api/#{API_VERSION}/#{path}"
    end

  end
end