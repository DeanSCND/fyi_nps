class BackupsController < ApplicationController  
  def index
    @config = "/Users/Adrian/Work/FYi/Net Promoter Score/"
    puts "PATH: " + @config

    script = 'pg_dump -U postgres nps_manager_development -f public/test.backup'
    logger.debug(script)
    system(script)



  end
end
