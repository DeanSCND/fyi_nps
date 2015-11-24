class RenameConfigsToSettings < ActiveRecord::Migration
  def change
    rename_table :configs, :settings
  end
end
