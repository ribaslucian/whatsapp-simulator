class Contact < ApplicationRecord

  belongs_to :entity
  belongs_to :category_acronym, class_name: 'Acronym', foreign_key: :category_acronym_id, optional: true
  belongs_to :mean_acronym, class_name: 'Acronym', foreign_key: :mean_acronym_id
  
  belongs_to :category, -> { select :name }, class_name: 'Acronym', foreign_key: :category_acronym_id, optional: true
  belongs_to :mean_of_contact, -> { select :name }, class_name: 'Acronym', foreign_key: :mean_acronym_id, optional: true

  
  # validations
  
  validates_presence_of :value, message: 'Preencha este campo'
  validates :value, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'E-mail inválido.' }, if: -> {self.mean_acronym_id == 36000}
  validates :value, uniqueness: { message: 'Este valor já está sendo utilizado.' }, if: -> {self.mean_acronym_id == 36000 || self.mean_acronym_id == 36001}
  
end
