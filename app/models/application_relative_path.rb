class ApplicationRelativePath < ActiveRecord::Base
  belongs_to :applications
  belongs_to :relative_paths
  has_many :payloads
end
