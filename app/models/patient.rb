class Patient < ActiveRecord::Base
  validates_uniqueness_of :email
  has_one :clinic, :foreign_key => 'practice_id', :primary_key => "practice_id"
  has_one :survey_result
  has_one :run, :foreign_key => 'id', :primary_key => "run_id"
  
  def self.to_csv()
    CSV.generate do |csv|
      csv << ["name", "email", "Practice Id", "Practice Name", "Visit Date", "RUN"]
      all.each do |patient|
        csv << patient.attributes.values_at(*["name", "email", "Practice Id", "Practice Name", "Visit Date", "RUN"])
      end
    end
  end
  
end
