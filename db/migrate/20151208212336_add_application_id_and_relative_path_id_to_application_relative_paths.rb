class AddApplicationIdAndRelativePathIdToApplicationRelativePaths < ActiveRecord::Migration
  def change
    add_column :application_relative_paths, :application_id, :integer
    add_column :application_relative_paths, :relative_path_id, :integer
  end
end
