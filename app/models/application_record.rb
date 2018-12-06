class ApplicationRecord < ActiveRecord::Base

  establish_connection :"#{Rails.env}"

  self.abstract_class = true
end
