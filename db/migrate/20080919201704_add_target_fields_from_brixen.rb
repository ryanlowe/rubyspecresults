class AddTargetFieldsFromBrixen < ActiveRecord::Migration
  def self.up
    rename_column :targets, :impl_branch, :ruby_version
    add_column    :targets, :impl_version, :string
  end

  def self.down
    rename_column :targets, :ruby_version, :impl_branch
    remove_column :targets, :impl_version
  end
end
