module TrafficSpy
  class Payload < ActiveRecord::Base
    belongs_to :application
    belongs_to :relative_path
    belongs_to :request_type
    belongs_to :resolution
    belongs_to :operating_system
    belongs_to :browser
    validates_uniqueness_of :application_id, scope: [:relative_path_string, :requested_at,
                                                     :responded_in, :referred_by,
                                                     :request_type_string, :event,
                                                     :operating_system_string, :browser_string,
                                                     :resolution_string, :ip_address,
                                                     :relative_path_id, :request_type_id,
                                                     :resolution_id, :operating_system_id,
                                                     :browser_id]

    def self.group_count_and_order(field)
      group(field).count.sort.sort_by { |key, count| [ -count, key ] }.to_h
    end

    def self.group_count_and_order_relative_path
      paths = group(:relative_path).count.map { |rel_path, count| [rel_path.path, count]}
      paths.sort_by { |key, count| [ -count, key ] }.to_h
    end

    def self.group_count_and_order_request_type
      paths = group(:request_type).count.map { |req_type, count| [req_type.verb, count]}
      paths.sort_by { |key, count| [ -count, key ] }.to_h
    end

    def self.group_count_and_order_resolution
      paths = group(:resolution).count.map { |res, count| [[res.width,res.height].join(" x "), count]}
      paths.sort_by { |key, count| [ -count, key ] }
    end

    def self.group_count_and_order_operating_system
      paths = group(:operating_system).count.map { |os, count| [os.op_system, count]}
      paths.sort_by { |key, count| [ -count, key ] }.to_h
    end

    ######### YO NEW METHOD! ###########
    def self.group_count_and_order_browser
      paths = group(:browser).count.map { |browser, count| [browser.browser_name, count]}
      paths.sort_by { |key, count| [ -count, key ] }.to_h
    end

    def self.group_average_and_order_response_times
      paths = group(:relative_path).average(:responded_in).map { |rel_path, count| [rel_path.path, count]}
      paths.sort_by{ |_, v| -v }
    end

    def self.matching(relative_path)
      rel_path = TrafficSpy::RelativePath.find_by(path: relative_path)
      if rel_path
        where(relative_path_id: rel_path.id)
      else
        []
      end
    end

    def self.max_response_time
      maximum(:responded_in)
    end

    def self.min_response_time
      minimum(:responded_in)
    end

    def self.avg_response_time
      average(:responded_in).round(2)
    end

    def self.get_top_3(field)
      group_count_and_order(field).take(3)
    end

    def self.get_top_3_relative_path
      group_count_and_order_relative_path.take(3)
    end

    def self.get_top_3_resolution
      group_count_and_order_resolution.take(3)
    end

    def self.get_top_3_operating_system
      group_count_and_order_operating_system.take(3)
    end

    ############# NEW METHODZZZZ #####
    def self.get_top_3_browser
      group_count_and_order_browser.take(3)
    end

    def self.requests_by_hour(hour)
      pluck(:requested_at).map { |t| t.hour }.count(hour)
    end
  end
end
