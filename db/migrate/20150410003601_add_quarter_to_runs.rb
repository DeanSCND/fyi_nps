class AddQuarterToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :quarter, :string
  end
end
