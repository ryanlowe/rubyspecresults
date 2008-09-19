class CreateTargets < ActiveRecord::Migration
  def self.up
    create_table :targets do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :destroyed_at
      t.integer  :created_by
      t.integer  :updated_by
      t.integer  :destroyed_by
      t.string   :secret
      t.string   :impl
      t.string   :spec_version
      t.string   :arch
      t.string   :os
      t.boolean  :continuous
      t.text     :notes
    end
  end

  def self.down
    drop_table :targets
  end
end
