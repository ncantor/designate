require File.join(File.dirname(__FILE__), '../designate')

Capistrano::Configuration.instance(:must_exist).load do
  namespace :zerigo do
    desc "RUN ONLY ON A SINGLE INSTANCE AT A TIME. Run the first time the app is deployed."
    task :first_time do
      hostname = variables[:logger].instance_variable_get("@options")[:actions].first
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