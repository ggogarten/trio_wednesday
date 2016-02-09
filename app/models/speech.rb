class Speech < ActiveRecord::Base
  belongs_to :candidate
  has_many :concepts
end
