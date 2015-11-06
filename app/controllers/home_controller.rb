class HomeController < ApplicationController  
  def index
    begin
      #@config = Rails.configuration.path
      @config = "/Users/Adrian/Work/FYi/Net Promoter Score/"
      puts "PATH: " + @config
    rescue
      @config = 'NOT DEFINED'
    end
  end
end
