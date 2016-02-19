module DistroMigrate
  def self.run()
    distroClinics = DistributionClinic.select("distribution_id, count(*) as dcount").group("distribution_id").having("count(*) > ?", 1)
    distroClinics.each do |dc|
      #puts "CLINIC: #{dc.distribution_id} #{dc.dcount}"
      contacts = DistributionContacts.where(distribution_id: dc.distribution_id)

      clinics_to_create = DistributionClinic.where(distribution_id: dc.distribution_id)

      clinics_to_create.each do |clinic|
        distro = Distribution.find(clinic.distribution_id)
        new_distro = Distribution.new
        new_distro.save


        clinic.distribution_id = new_distro.id
        clinic.save

        #puts "DISTRO: #{distro.id}"
        contacts.each do |contact|
          puts "Contact: #{contact.fyi_contact_id}"
          new_contact = DistributionContacts.new
          new_contact.distribution_id = new_distro.id
          new_contact.fyi_contact_id = contact.fyi_contact_id

          new_contact.save
        end
      end
    end
  end

  #raise "This script expects no arguments" unless ARGV.length === 3

  DistroMigrate.run()

end