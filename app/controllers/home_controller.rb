class HomeController < ApplicationController  
  def index
    @config = Rails.configuration.path
    puts "PATH: " + @config
  end
end
