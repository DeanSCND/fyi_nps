class AddStatTypeToPracticeReports < ActiveRecord::Migration
  def change
    add_column :practice_reports, :stat_type, :string
  end
end
