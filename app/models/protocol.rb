class Protocol < ApplicationRecord
  belongs_to :applicant, class_name: 'Entity', foreign_key: :applicant_entity_id, optional: true
  belongs_to :registered, class_name: 'Entity', foreign_key: :registered_entity_id, optional: true
  belongs_to :responsible, class_name: 'Entity', foreign_key: :responsible_entity_id, optional: true

  belongs_to :type_acronym, class_name: 'Acronym', foreign_key: :type_acronym_id
  belongs_to :status_acronym, class_name: 'Acronym', foreign_key: :status_acronym_id
  belongs_to :type, -> { select :name }, class_name: 'Acronym', foreign_key: :type_acronym_id, optional: true
  belongs_to :status, -> { select :name }, class_name: 'Acronym', foreign_key: :status_acronym_id, optional: true

  has_many_attached :files

end
