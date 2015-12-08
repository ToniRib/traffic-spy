class AddRequestTypeIdToPayload < ActiveRecord::Migration
  def change
    add_column :payloads, :request_type_id, :integer
  end
end
