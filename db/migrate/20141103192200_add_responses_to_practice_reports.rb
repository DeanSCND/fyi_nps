class AddResponsesToPracticeReports < ActiveRecord::Migration
  def change
    add_column :practice_reports, :responses, :integer
  end
end
