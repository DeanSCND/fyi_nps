class AddRunIdToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :run_id, :integer
  end
end
