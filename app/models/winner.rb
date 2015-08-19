class Winner < ActiveRecord::Base
	belongs_to :patient
	belongs_to :clinic, :foreign_key => 'practice_id', :primary_key => "practice_id"
end
