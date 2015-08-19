class AddPracticeGroupIdToClinics < ActiveRecord::Migration
  def change
    add_column :clinics, :practice_group_id, :integer
  end
end
