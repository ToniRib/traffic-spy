module TrafficSpy
  class Payload < ActiveRecord::Base
    belongs_to :application_relative_path_id
    validates_uniqueness_of :application_relative_path_id, scope: [:relative_path, :requested_at,
                                                     :responded_in, :referred_by,
                                                     :request_type, :event,
                                                     :operating_system, :browser,
                                                     :resolution, :ip_address]
  end
end
