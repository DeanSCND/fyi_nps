class CreatePracticeGroups < ActiveRecord::Migration
  def change
    create_table :practice_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
