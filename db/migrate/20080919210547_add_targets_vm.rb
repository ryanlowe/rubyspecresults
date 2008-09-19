class AddTargetsVm < ActiveRecord::Migration
  def self.up
    add_column :targets, :vm, :string
  end

  def self.down
    remove_column :targets, :vm
  end
end
