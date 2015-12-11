class RenameBrowserAndAddBrowserIdInPayloads < ActiveRecord::Migration
  def change
    rename_column :payloads, :browser, :browser_string
    add_column :payloads, :browser_id, :integer
  end
end
