class DistributionClinic < ActiveRecord::Base
    has_one :clinic, :foreign_key => 'practice_id', :primary_key => 'practice_id'
end
