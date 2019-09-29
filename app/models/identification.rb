class Identification < ApplicationRecord
  belongs_to :entity

  belongs_to :type, -> { select :name }, class_name: 'Acronym', foreign_key: :type_acronym_id
end
