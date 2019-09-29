# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Acronym.update

entity = Entity.create!(
  id: 'b6417740-afb3-42db-bef0-ec0c0e9086ad',
  name: 'Usuário',
  legal: true,
  identifications_attributes: [{
      type_acronym_id: 100001,
      value: '000.000.000-00'
  }],
  user_attributes: {
    password_sha1: Digest::SHA1.hexdigest('123456')
  },
)