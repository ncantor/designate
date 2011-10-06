require File.join(File.dirname(__FILE__), '../designate')

Capistrano::Configuration.instance(:must_exist).load do
  namespace :zerigo do
    desc "Run only on individual servers, not entire roles."
    task :first_time do
      hostname = capture('hostname -s').chomp
      dns_names = []
      roles.each do |role| 
        dns_names << role[1].instance_variable_get("@static_servers").first.instance_variable_get("@host")
      end
      zone = Designate::Client.new().find_zone_by_domain()
      zone.create_host('CNAME', "#{hostname}.#{zerigo_config[:domain]}", {:hostname => "#{hostname}-#{application}"})
      zone.create_host('CNAME', dns_names.first, {:hostname => hostname})
    end
    
    def zerigo_config()
      YAML.load(File.new("config/zerigo.yml"))
    end
  end
end