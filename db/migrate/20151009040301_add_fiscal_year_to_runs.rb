class AddFiscalYearToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :fiscal_year, :string
  end
end
