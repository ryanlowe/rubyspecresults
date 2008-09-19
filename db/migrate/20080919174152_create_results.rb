class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :destroyed_at
      t.integer  :created_by
      t.integer  :updated_by
      t.integer  :destroyed_by
      t.integer  :target_id
      t.text     :log
      t.integer  :files_count
      t.integer  :examples_count
      t.integer  :expectations_count
      t.integer  :failures_count
      t.integer  :errors_count
    end
  end

  def self.down
    drop_table :results
  end
end
