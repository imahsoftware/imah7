class Graph < ApplicationRecord
  has_attached_file :graphimage
  validates_attachment_content_type :graphimage, content_type: /\Aimage\/.*\z/
end