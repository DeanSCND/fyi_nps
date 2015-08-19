class CreateDistributionPracticeGroups < ActiveRecord::Migration
  def change
    create_table :distribution_practice_groups do |t|
      t.integer :distribution_id
      t.integer :practice_group_id

      t.timestamps
    end
  end
end
