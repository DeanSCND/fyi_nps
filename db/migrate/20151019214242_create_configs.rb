class CreateConfigs < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
