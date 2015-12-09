class CreateRelativePaths < ActiveRecord::Migration
  def change
    create_table :relative_paths do |t|
      t.string :path
    end
  end
end
