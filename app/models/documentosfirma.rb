class Documentosfirma < ApplicationRecord
  belongs_to :user

  has_attached_file :documentofirma
  validates_attachment_content_type :documentofirma, content_type: /\A*\/.*\Z/
  do_not_validate_attachment_file_type :documentofirma
end
