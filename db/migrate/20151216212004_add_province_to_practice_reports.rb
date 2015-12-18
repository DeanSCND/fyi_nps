class AddProvinceToPracticeReports < ActiveRecord::Migration
  def change
    add_column :practice_reports, :province, :string
  end
end
