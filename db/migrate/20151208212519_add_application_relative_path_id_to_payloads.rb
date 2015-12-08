class AddApplicationRelativePathIdToPayloads < ActiveRecord::Migration
  def change
    add_column :payloads, :application_relative_path_id, :integer
  end
end
