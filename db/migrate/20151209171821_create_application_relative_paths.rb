class CreateApplicationRelativePaths < ActiveRecord::Migration
  def change
    create_table :application_relative_paths do |t|
      t.integer :application_id
      t.integer :relative_path_id
    end
  end
end
