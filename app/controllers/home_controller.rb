class HomeController < ApplicationController  
  def index
    #@config = Rails.configuration.path
    @config = "/Users/Adrian/Work/FYi/Net Promoter Score/"
    puts "PATH: " + @config
  end
end
