class AddStartEndMonthToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :start_date, :string
    add_column :runs, :end_date, :string
  end
end
