class ChangeOptOutCommentType < ActiveRecord::Migration 
  def self.up
    change_table :survey_answers do |t|
      t.change :a3o, :text
    end
    change_table :survey_answers do |t|
      t.change :a4o, :text
    end
    change_table :survey_answers do |t|
      t.change :a5o, :text
    end
    change_table :survey_answers do |t|
      t.change :a6o, :text
    end
    change_table :survey_answers do |t|
      t.change :a7o, :text
    end
    change_table :survey_answers do |t|
      t.change :a8o, :text
    end
    change_table :survey_answers do |t|
      t.change :n1o, :text
    end
    change_table :survey_answers do |t|
      t.change :n2o, :text
    end
  end
end
