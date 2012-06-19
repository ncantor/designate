require File.join(File.dirname(__FILE__), '../designate')
require 'rubygems'
require 'capistrano'
require 'capify-ec2'

Capistrano::Configuration.instance(:must_exist).load do
  namespace :zerigo do
    desc "Run only on individual servers, not entire roles."
    task :first_time do
      hostname = capture('hostname -s').chomp
      dns_names = []
      roles.each do |role| 
        dns_names << role[1].instance_variable_get("@static_servers").first.instance_variable_get("@host")
      end
      zone = Designate::Client.new().find_or_create_zone()
      zone.create_host('CNAME', dns_names.first, {:hostname => hostname})
      
      if zerigo_config[:subdomain].nil?
        zone.create_host('CNAME', "#{hostname}.#{zerigo_config[:domain]}", {:hostname => "#{hostname}-#{application}"})
      else
        subzone = Designate::Client.new().find_or_create_zone("#{zerigo_config[:subdomain]}.#{zerigo_config[:domain]}")
        subzone.create_host('CNAME', "#{hostname}.#{zerigo_config[:domain]}", {:hostname => "#{hostname}"})
        cleanup_hosts(subzone, zone)
      end
    end
    
    def zerigo_config()
      YAML.load(File.new("config/zerigo.yml"))
    end
    
    def cleanup_hosts(subzone, zone)
      return if !zerigo_config[:subdomain]
      expired_hosts = get_expired_hosts(subzone)
      delete_hosts(expired_hosts, subzone)
      delete_hosts(expired_hosts, zone)
    end
    
    def get_expired_hosts(subzone)
      hostnames = []
      capec2 = CapifyEc2.new
      roles.each {|role| hostnames << capec2.get_instances_by_role(role[0]).map {|instance| instance.name}}
      hostnames.flatten!
      subzone.hosts.delete_if {|host| hostnames.find {|hostname| hostname == host.hostname}}.map {|host| host.hostname}
    end
    
    def delete_hosts(expired_hosts, zone)
      zone.hosts.delete_if {|host| !expired_hosts.find {|hostname| hostname == host.hostname}}
      zone.hosts.each {|host| p "Deleting expired host: #{host.fqdn}"; host.destroy} rescue puts "Looks like #{host.fqdn} has already been deleted"
    end
  end
end