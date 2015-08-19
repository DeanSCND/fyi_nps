class HomeController < ApplicationController  
  include Fluid
  require 'json'
  def index
    #fluid = Fluid::Api.new('dean.skelton@fyidoctors.com', 'Fyidoctors2013')
    #val = fluid.contacts(1)
    #total = val["count"]
    
    #logger.debug("RAW: " + val["results"][0]["name"])
    #jval = JSON.parse(val.to_json)
    #logger.debug("JSON: " + jval["results"][0]["name"])
  end
end
