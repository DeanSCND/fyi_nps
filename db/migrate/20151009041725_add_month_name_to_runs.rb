class AddMonthNameToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :month_name, :string
  end
end
