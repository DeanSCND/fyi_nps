class AddPracticeCodeToPracticeGroups < ActiveRecord::Migration
  def change
    add_column :practice_groups, :practice_code, :integer
  end
end
