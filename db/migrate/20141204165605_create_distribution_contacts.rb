class CreateDistributionContacts < ActiveRecord::Migration
  def change
    create_table :distribution_contacts do |t|
      t.integer :distribution_id
      t.integer :fyi_contact_id

      t.timestamps
    end
  end
end
