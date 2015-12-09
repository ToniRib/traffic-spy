class RenameApplicationIdInPayloads < ActiveRecord::Migration
  def change
    rename_column :payloads, :application_id, :application_relative_path_id
  end
end
