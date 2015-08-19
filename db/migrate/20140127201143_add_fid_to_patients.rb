class AddFidToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :fid, :integer
  end
end
