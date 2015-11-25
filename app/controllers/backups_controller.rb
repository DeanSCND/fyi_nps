class BackupsController < ApplicationController  
  def index
    script = 'pg_dump -U postgres nps_manager_development -f public/test.backup'
    logger.debug(script)
    system(script)
  end
end
