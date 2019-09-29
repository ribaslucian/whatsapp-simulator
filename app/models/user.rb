class User < ApplicationRecord
  belongs_to :entity
    


  ##
  def self.login params
    # only one
    if !['cpf', 'cnpj'].any? { |k| params.has_key? k }
      return {error: 'error', message: 'missing_actions_fields1'}
    end

    # mandatory
    if !(['password', 'browser', 'os', 'mac', 'application'] - params.keys).empty?
      return {error: 'error', message: 'missing_action_fields2'}
    end

    begin

      # user exists?
        if params.include?(:cpf)
          entity_type = Person.select(:entity_id, 'cpf AS document').find_by_cpf(params[:cpf])
        elsif params.include?(:cnpj)
          entity_type = Corporate.select(:entity_id, 'cnpj AS document').find_by_cnpj(params[:cnpj])
        end

        entity = Entity.select(:id, :name).find(entity_type.entity_id)
        user = User.select(:id).find_by(
          blocked: false,
          password: params[:password],
          entity_id: entity.id
        )

        application = Application.select(:id).find_by_name(params[:application])

        has_connection = Connection.where(
          "(user_id = '#{user.id}') AND (date_logout IS NULL) AND (application_id = '#{application.id}') AND (date_expiration <= (created + INTERVAL '4 hours'))"
        ).count

        contracts_array = Entity.contracts_array(entity.id)

        if has_connection <= 0
          # create connection - SHOULD_BE_TRIGGER
            ActiveRecord::Base.connection.execute "UPDATE connections SET date_logout = NOW() WHERE user_id = '#{user.id}' AND date_logout IS NULL;"
            Connection.create!(
              user_id: user.id,
              entity_id: entity.id,
              application_id: application.id,
              browser: ActiveRecord::Base.connection.quote(params[:browser]),
              os: params[:os],
              mac: params[:mac]
            ).id
        end
    rescue => ex
      return {error: 'error', message: 'not_found_user_or_contracts', exception: ex}
    end

    return {error: false, name: entity.name, id: entity.id, document: entity_type.document, contracts: contracts_array}
  end

  ##
  def self.connected params
    # mandatory
    if !(['id', 'application'] - params.keys).empty?
      return {error: 'error', message: 'missing_action_fields2'}
    end

    begin
      entity = Entity.select(:id, :name).find_by_id(params[:id])
      user = User.select(:id).find_by(blocked: false, entity_id: entity.id)

      application = Application.select(:id).find_by_name(params[:application])

      Connection.select(:id).where("
        (user_id = '#{user.id}') AND (date_logout IS NULL) AND (application_id = '#{application.id}') AND (date_expiration <= (created + INTERVAL '4 hours'))
      ").first.id

      contracts_array = Entity.contracts_array(entity.id)
    rescue => ex
      return {error: 'error', message: 'not_found_connection', exception: ex}
    end

    return {error: false, name: entity.name, id: entity.id, contracts: contracts_array}
  end
end
