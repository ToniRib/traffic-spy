class CreateBrowsers < ActiveRecord::Migration
  def change
    create_table :browsers do |t|
      t.string :browser_name
    end
  end
end
