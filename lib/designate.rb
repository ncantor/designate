require 'rest_client'
require 'crack/xml'
require File.expand_path(File.dirname(__FILE__) + '/designate/client')
require File.expand_path(File.dirname(__FILE__) + '/designate/zone')
require File.expand_path(File.dirname(__FILE__) + '/designate/template')
require File.expand_path(File.dirname(__FILE__) + '/designate/host')

module Designate
  class InvalidHostType < StandardError; end
end