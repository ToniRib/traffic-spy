class CreatePayloads < ActiveRecord::Migration
  def change
    create_table :payloads do |t|
      t.datetime :requested_at
      t.integer  :responded_in
      t.string   :referred_by 
      t.string   :parameters
      t.string   :ip_address
    end
  end
end
