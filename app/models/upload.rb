class Upload < ApplicationRecord
  belongs_to :entity, optional: true
  belongs_to :type, -> { select :name }, class_name: 'Acronym', foreign_key: :type_acronym_id, optional: true
end
