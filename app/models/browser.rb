module TrafficSpy
  class Browser < ActiveRecord::Base
    has_many :payloads
  end
end
