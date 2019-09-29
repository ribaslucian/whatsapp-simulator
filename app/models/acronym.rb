class Acronym < ApplicationRecord
  
  def self.update
    self.delete_all
    
    Acronym.create!([

      # 1..4999 applications
      {id: 1, name: 'Aplicação Web', data_refer: 'application.platform'},
      {id: 2, name: 'Aplicação Desktop', data_refer: 'application.platform'},
      {id: 3, name: 'Aplicação Mobile', data_refer: 'application.platform'},

      # 5000..5999 keys
      {id: 5000, name: 'API: Permissão de Acesso ', data_refer: 'keys.type'},

      # 25000..29999 entities
      {id: 25000, name: 'Masculino', data_refer: 'entities.gender'},
      {id: 25001, name: 'Feminimo', data_refer: 'entities.gender'},
      {id: 25002, name: 'Não-Binária', data_refer: 'entities.gender'},

      # 30000..34999 addresses
      {id: 30000, name: 'Moradia em Residencial', data_refer: 'addresses.type'},
      {id: 30001, name: 'Moradia em APTO', data_refer: 'addresses.type'},

      # 35000..39999 contacts
      {id: 35000, name: 'Contato Pessoal', data_refer: 'contacts.category'},
      {id: 35001, name: 'Contato Corporativo', data_refer: 'contacts.category'},
      {id: 35002, name: 'Contato Comercial', data_refer: 'contacts.category'},

      {id: 36000, name: 'E-mail', data_refer: 'contacts.mean'},
      {id: 36001, name: 'Telefone', data_refer: 'contacts.mean'},

      # 60000..69999 protocols
      {id: 60000, name: 'Aberto', data_refer: 'protocols.status'},
      {id: 60001, name: 'Cancelado', data_refer: 'protocols.status'},
      {id: 60002, name: 'Concluído', data_refer: 'protocols.status'},

      {id: 60102, name: 'Alteração de Dados do Titular', data_refer: 'protocols.type'},
      {id: 60103, name: 'Ocorrência', data_refer: 'protocols.type'},
      {id: 60104, name: 'Solicitação', data_refer: 'protocols.type'},
      {id: 60105, name: 'Sugestão', data_refer: 'protocols.type'},
      {id: 60106, name: 'Dúvida', data_refer: 'protocols.type'},
      {id: 60107, name: 'Reclamação', data_refer: 'protocols.type'},
      {id: 60108, name: 'Outro', data_refer: 'protocols.type'},

      # 70000..74999 letters
      {id: 70000, name: 'Carta de Admissão Emitida', data_refer: 'letters.type'},
      {id: 70001, name: 'Carta de Admissão Enviada', data_refer: 'letters.type'},

      # 75000..79999 contracts
      {id: 75000, name: 'Titular',      data_refer: 'contracts.type'},
      {id: 75001, name: 'Lojista',      data_refer: 'contracts.type'},
      {id: 75002, name: 'Contratante',  data_refer: 'contracts.type'},
      {id: 75003, name: 'Empregado',    data_refer: 'contracts.type'},
      {id: 75004, name: 'Representante Legal',  data_refer: 'contracts.type'},
      {id: 75005, name: 'Entidade Associada',   data_refer: 'contracts.type', description: 'Lojas da Mesma Rede'},
      {id: 75006, name: 'Emissor de Cartão',    data_refer: 'contracts.type'},
      {id: 75007, name: 'Bandeira',             data_refer: 'contracts.type'},

        
      # 90000..99999 uploads
      {id: 90000, name: 'Lote de Convêniados (Platina CSV)', data_refer: 'uploads.type'},
      {id: 90001, name: 'Lote de Recargas (Platina CSV)', data_refer: 'uploads.type'},

      # 100000..104999 documents
      {id: 100000, name: 'RG - Registro Geral', data_refer: 'identifications.name'},
      {id: 100001, name: 'CPF - Cadastro de Pessoa Física', data_refer: 'identifications.name'},
      {id: 100002, name: 'CNPJ - Cadastro Nacional da Pessoa Jurídica', data_refer: 'identifications.name'},
      {id: 100003, name: 'Registro Municipal', data_refer: 'identifications.name'},
      {id: 100004, name: 'Registro Estadual', data_refer: 'identifications.name'},
      {id: 100005, name: 'Razão Social', data_refer: 'identifications.name'},
      {id: 100006, name: 'Nome Social', data_refer: 'identifications.name'},
      {id: 100007, name: 'Nome Artístico', data_refer: 'identifications.name'},
    ])
  end
  
end
