module TrafficSpy
  class Application < ActiveRecord::Base
    has_many :application_relative_paths
    validates_presence_of :identifier, :root_url
    validates_uniqueness_of :identifier
  end
end
