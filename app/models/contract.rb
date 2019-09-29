class Contract < ApplicationRecord
  attr_accessor :contracted_entity_name, :contractor_entity_name
  
#  has_many :fees, inverse_of: :contract, dependent: :destroy
  has_many :fees, dependent: :destroy

  belongs_to :contractor, class_name: 'Entity', foreign_key: :contractor_entity_id, optional: true
  belongs_to :contracted, class_name: 'Entity', foreign_key: :contracted_entity_id, optional: true

  has_many :identifications, -> { where('name_acronym_id = 100001 OR name_acronym_id = 100002') }, through: :contracted

  belongs_to :type, -> { select :name }, class_name: 'Acronym', foreign_key: :type_acronym_id
  
  accepts_nested_attributes_for :fees, reject_if: :all_blank, allow_destroy: true
end
