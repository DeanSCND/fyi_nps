class Contact < ActiveRecord::Base
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      logger.debug("HERE")
      #all.each do |contact|
      #  csv << product.attributes.values_at(*column_names)
      #end
    end
  end
end