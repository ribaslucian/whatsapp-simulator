class UpdatePassword < ApplicationRecord
  
  attr_accessor :password_new
  
  self.table_name = 'users'
  
  validates_presence_of :password_raw, 
    message: 'Preencha este campo'

  validates_presence_of :password_new,
    message: 'Preencha este campo'

  validates_presence_of :password_new_confirmation,
    message: 'Preencha este campo'

  validates_format_of :password_new,
    with: /\A(?=(.*[a-zA-Z]){2})(?=(.*[0-9]){2})/i,
    message: 'Deve possuir ao menos duas letras e dois números'

  validates_confirmation_of :password_new,
    message: 'Devem ser iguais'

#  validates :password_raw, check_current_password: { message: 'Senha inválida' }

end
