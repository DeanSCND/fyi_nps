class AddRunToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :run, :string
  end
end
