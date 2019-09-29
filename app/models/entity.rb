class Entity < ApplicationRecord
  belongs_to :gender, -> { select :name }, class_name: 'Acronym', foreign_key: :gender_acronym_id, optional: true
  has_one :user #, dependent: :destroy

  has_many :identifications, dependent: :destroy # , -> { includes :name }
  has_many :contacts, -> { order priority: :desc}
  has_many :emails, -> { where mean_acronym_id: 36000 }, class_name: 'Contact'
  has_many :phones, -> { where mean_acronym_id: 36001 }, class_name: 'Contact'
  has_many :addresses
  has_many :banks
  has_many :uploads
  has_many :uploads_employees, -> { where(processed: false, type_acronym_id: 90000) }, class_name: 'Upload'

  has_many :keys
  has_many :connections
  has_and_belongs_to_many :applications

  # has_many :cards, -> { order(number: :desc).limit(1) }
  has_many :cards, -> { order date_emission: :desc }
  has_many :balances

  has_many :contracteds, -> { select('*').joins 'JOIN entities ON contracted_entity_id = entities.id' }, class_name: 'Contract', foreign_key: :contractor_entity_id
  has_many :contractors, -> { select('*').joins 'JOIN entities ON contractor_entity_id = entities.id' }, class_name: 'Contract', foreign_key: :contracted_entity_id

  has_many :my_devices, class_name: 'Device', foreign_key: :owner_entity_id
  has_many :leased_devices, class_name: 'Device', foreign_key: :local_entity_id

  has_many :protocols_by_me, class_name: 'Protocol', foreign_key: :requester_entity_id
  has_many :protocols_to_me, class_name: 'Protocol', foreign_key: :requested_entity_id

  has_many :billings_by_me, class_name: 'Billing', foreign_key: :requester_entity_id
  has_many :billings_to_me, class_name: 'Billing', foreign_key: :requested_entity_id

  has_many :letters_by_me, class_name: 'Letter', foreign_key: :origin_entity_id
  has_many :letters_to_me, class_name: 'Letter', foreign_key: :destiny_entity_id

  has_many :debits, class_name: 'Transfer', foreign_key: :origin_entity_id
  has_many :credits, class_name: 'Transfer', foreign_key: :destiny_entity_id

  has_many :pending_debits, class_name: 'PendingTransfer', foreign_key: :origin_entity_id
  has_many :pending_credits, class_name: 'PendingTransfer', foreign_key: :destiny_entity_id

  has_many :blocks, class_name: 'Blacklist', foreign_key: :blocker_entity_id
  
  
  has_one :email, -> { limit(1).order(priority: :asc, created: :desc).where(mean_acronym_id: 36000) }, class_name: 'Contact'
  has_one :phone, -> { limit(1).order(priority: :asc, created: :desc).where(mean_acronym_id: 36001) }, class_name: 'Contact'
  
  has_one :view, class_name: 'View::Entity', foreign_key: :id

  accepts_nested_attributes_for :user,
  :identifications, :emails, :addresses, :phones, :banks,
  :keys, :connections,
  :cards, :balances,
  :contracteds, :contractors,
  :my_devices, :leased_devices,
  :protocols_by_me, :protocols_to_me,
  :billings_by_me, :billings_to_me,
  :letters_by_me, :letters_to_me,
  :debits, :credits,
  :pending_debits, :pending_credits,
  :email, :phone,
  allow_destroy: true

  def transfers
    {
      error: false,
      results: Transfer.where(
        "balance_origin_id = (SELECT id FROM balances WHERE entity_id = #{self.id}) OR
        balance_destiny_id = (SELECT id FROM balance WHERE entity_id = #{self.id})",
      ).order(:id)
    }
  end

  def pending_transfers
    {
      error: false,
      results: PendingTransfer.where(
        "balance_origin_id = (SELECT id FROM balances WHERE entity_id = #{self.id}) OR
        balance_destiny_id = (SELECT id FROM balance WHERE entity_id = #{self.id})",
      ).order(:id),
    }
  end

  def self.extract id
    {
      error: false,
      results: ActiveRecord::Base.connection.execute("
        SELECT * FROM extract_transfers('#{id}'::uuid);
      ")
    }
  end

  def self.find_extract params
    entity = params['e']
    transfer = params['t']
    {
      error: false,
      results: ActiveRecord::Base.connection.execute("
        SELECT * FROM extract_transfers('#{entity}'::uuid) WHERE id = '#{transfer}';
      ").first
    }
  end

  def self.extract_pending id
    {
      error: false,
      results: ActiveRecord::Base.connection.execute("
        SELECT * FROM extract_pending_transfers('#{id}'::uuid);
      ")
    }
  end

  def self.employees_add options
    begin
      Entity.transaction do



        contractor = Entity.select(:id).find(options['contractor_id'])

        options['employees'].each do |employee_sended|

          # employee = (employee_sended.to_h.except('delivery_location')).to_h

          # contract
          employee['contractors_attributes'] = [{
              contractor_entity_id: contractor.id,
              type_acronym_id: 75000
          }];

          # ballances inherit contractor
          employee['balances_attributes'] = []
          contractor.balances.each do |balance|
            employee['balances_attributes'].push({
              coin_id: balance.coin_id
            })
          end

          # user
          employee['user_attributes'] = {
            password_raw: (password = SecureRandom.hex[0..6]),
            password_sha1: Digest::SHA1.hexdigest(password)
          }
          employee = Entity.create!(employee)

          # card
          # card = Card.create!({
          #   entity_id: employee.id,
          #   code: rand(100000..999999),
          #   security_code: rand(100..999),
          #   password_raw: (password = rand(000000..999999)),
          #   password_sha1: Digest::SHA1.hexdigest(password.to_s),
          #   solicitation_acronym_id: employee_sended['delivery_location']
          # });

          # card balances relation
          employee.balances.each do |balance|
            ActiveRecord::Base.connection.execute("
              INSERT INTO balances_cards(balance_id, card_id)
              VALUES('#{balance.id}', '#{card.id}');
            ");
          end
        end
      end
    rescue => ex
      return {error: true, message: 'error_employees_add', exception: ex}
    end
  end


  # params {
  #   cards: [...],
  #   balances: [...],
  #   identifications: [...],
  #   cards_solicitation: ...
  #   contractor_id: ...
  #   ...
  # }
  def self.employee_add params
    employee = {}

    begin
      Entity.transaction do
        contractor = Entity.select(:id).find(params['contractor_id'])

        # prepare employee
        params.each do |k, v|
          next if (k == 'cards_solicitation' || k == 'contractor_id')

          if v.kind_of?(Array)
            employee["#{k}_attributes"] = v
          else
            employee[k] = v
          end
        end

        employee['identifications_attributes'][0]['name_acronym_id'] = 100001

        # contract
        employee['contractors_attributes'] = [{
            contractor_entity_id: contractor.id,
            type_acronym_id: 75000
        }];

        employee['balances_attributes'] = []
        employee['cards_attributes'] = []

        # user
        employee['user_attributes'] = {
          password_raw: (password = SecureRandom.hex[0..6]),
          password_sha1: Digest::SHA1.hexdigest(password)
        }

        # ballances: inherit contractor
        contractor.balances.each do |balance|
          employee['balances_attributes'].push({
            coin_id: balance.coin_id
          })

          # card: one per balance
          employee['cards_attributes'].push({
            solicitation_acronym_id: params['cards_solicitation']
          })
        end

        employee = Entity.create!(employee)
        employee.cards.select :id

        employee.balances.each_with_index do |balance, k|
          card = employee.cards[k]

          ActiveRecord::Base.connection.execute("
            INSERT INTO balances_cards(balance_id, card_id)
            VALUES('#{balance.id}', '#{card.id}');
          ");
        end
      end
    rescue => ex
      return {error: true, message: 'error_employee_add', exception: ex}
    end

    return {error: false, results: {name: employee.name, id: employee.id}}
  end

  def self.representant id
    begin
      c = Contract.select(:contracted_entity_id).find_by({
        contractor_entity_id: id,
        type_acronym_id: 75004
      })
      return {error: false, results: nil} if (!c)

      e = Entity.find(c.contracted_entity_id)
      return {
        error: false,
        results: JSON.parse(e.to_json(include: [:addresses, :phones, :emails]))
      }
    rescue => ex
      return {error: true, exception: ex}
    end
  end


  def self.employee_rescind options
    begin
      Contract.find_by(
        entity_contractor_id: Entity.select(:id).find(options['entity_contractor']).id,
        entity_contracted_id: Entity.select(:id).find(options['entity_contracted']).id,
        type_acronym_id: 75000,
      ).destroy
    rescue => ex
      return {error: 'error', message: 'error_employee_rescind', exception: ex}
    end

    return {error: false}
  end


  def self.contracts params
    begin
      contractor = Entity.select(:id).where(id: params['contractor']).first.id
      # type 7500

      stores = ActiveRecord::Base.connection.execute("
        SELECT entities.id, name
        FROM contracts
        JOIN entities ON (entities.id = contracts.contracted_entity_id)
        WHERE (
        	contractor_entity_id = '#{contractor}'
        	AND contracts.type_acronym_id = #{params['type']}::BIGINT
          AND contracts.archived IS NULL
        )
        ORDER BY name;
      ")
    rescue => e
      return {error: true, info: 1, exception: e}
    end

    return {
      error: false,
      results: stores
    }
  end


  def self.extract_period params
      # input: options = {
      #   entity: uui,
      #   date_start: string,
      #   date_end: string,
      #   last_transfer: ids
      # }
      #
      # output: {
      #   results: {
      #     entity: uuid
      #     date_start: date,
      #     date_end: date,
      #     total_extract: float
      #     total_global: float
      #     transfers: []
      #   }
      # }

      # apenas o campo entity e obrigatorio
      if (!params.has_key?('entity'))
        return {error: true, info: 1, message: 'missing_params'}
      end

      # processando
      entity = date_start = date_end = total_extract = total_global = nil
      begin

        # obtemos a entidade do extrato
        entity = Entity.select(:id).where(id: params['entity']).first.id

        # verificando datas
          # verificando validade: data inicial
          if params.has_key?('date_start')
            #date_start = Time.zone.at((params['date_start'] + ' 03:01').to_datetime)
            date_start = (params['date_start'] + ' 00:01').to_datetime
          else
            # caso nao informado a data inicial sera comeco do mes
            date_start = Time.now.change(day: 1, hour: 0, min: 0, sec: 1)
          end

          # verificando validade: data final
          if params.has_key?('date_end')
            #date_end = Time.zone.at (params['date_end'] + ' 23:59').to_datetime
            date_end = (params['date_end'] + ' 23:59').to_datetime
          else
            # caso nao informado a data final sera final do mes
            date_end = Time.now.end_of_month
          end

          # data inicial deve ser passado
          return {error: true, info: 2} if (date_start != nil && date_start.future?())

          # data final deve ser menor que inicial
          return {error: true, info: 3} if !(date_start < date_end)

        count = ActiveRecord::Base.connection.execute("
          SELECT count(*)
          FROM extract_transfers('#{entity}'::uuid)
          WHERE (date at time zone 'america/sao_paulo') >= '#{date_start}'
          AND (date at time zone 'america/sao_paulo') <= '#{date_end}'
        ")

        # mais de 1000 transações
        return {error: true, info: 4} if (count.first['count'] > 1000)

        # calculando totais
        total_extract_credited = ActiveRecord::Base.connection.execute("
          SELECT sum(value)
          FROM extract_transfers('#{entity}'::uuid)
          WHERE (date at time zone 'america/sao_paulo') >= '#{date_start}'
          AND (date at time zone 'america/sao_paulo') <= '#{date_end}'
          AND destiny_entity_id = '#{entity}';
        ")

        total_extract_debited = ActiveRecord::Base.connection.execute("
          SELECT sum(value)
          FROM extract_transfers('#{entity}'::uuid)
          WHERE (date at time zone 'america/sao_paulo') >= '#{date_start}'
          AND (date at time zone 'america/sao_paulo') <= '#{date_end}'
          AND origin_entity_id = '#{entity}';
        ")

        # total_global_credited = ActiveRecord::Base.connection.execute("
        #   SELECT sum(value) FROM extract_transfers('#{entity}'::uuid)
        #   WHERE destiny_entity_id = '#{entity}';
        # ")
        #
        # total_global_debited = ActiveRecord::Base.connection.execute("
        #   SELECT sum(value) FROM extract_transfers('#{entity}'::uuid)
        #   WHERE origin_entity_id = '#{entity}';
        # ")

        if params.has_key?('last_transfer')
          transfers = ActiveRecord::Base.connection.execute("
            SELECT * FROM extract_transfers('#{entity}'::uuid)
            WHERE (date at time zone 'america/sao_paulo') >= '#{date_start}'
            AND (date at time zone 'america/sao_paulo') <= '#{date_end}'
            AND ids < #{params['last_transfer']}
            LIMIT 10;
          ")
        elsif
          transfers = ActiveRecord::Base.connection.execute("
            SELECT * FROM extract_transfers('#{entity}'::uuid)
            WHERE (date at time zone 'america/sao_paulo') >= '#{date_start}'
            AND (date at time zone 'america/sao_paulo') <= '#{date_end}'
            LIMIT 10;
          ")
        end
      rescue => ex
        return {error: true, info: 4, exception: ex}
      end

      return {
        results: {
          entity: entity,
          date_start: date_start.strftime('%d/%m/%Y'),
          date_end: date_end.strftime('%d/%m/%Y'),
          total_extract_credited: total_extract_credited.first['sum'],
          total_extract_debited: total_extract_debited.first['sum'],
          # total_global_credited: total_global_credited.first['sum'],
          # total_global_debited: total_global_debited.first['sum'],
          transfers: transfers,
          count: count.first['count']
        }
      }
  end

  def self.by_coin_rate options
    #  options [name: 'ana', coin_id: 'uuid', rate: "acronyms.date_refer = 'rates.name'"]

    begin
      entities = ActiveRecord::Base.connection.execute("
        SELECT entities.id, name, identifications.value, contracts.id AS \"contract_id\", fees.id AS \"fees_id\"
        FROM entities
        LEFT JOIN identifications ON identifications.entity_id = entities.id
        LEFT JOIN contracts ON contracted_entity_id = entities.id
        LEFT JOIN fees ON fees.contract_id = contracts.id
        WHERE
        	(identifications.name_acronym_id = 100001 OR identifications.name_acronym_id = 100002)
        	AND name ~* '#{options['name']}'
        	AND fees.coin_id = '#{options['coin_id']}'
        	AND fees.name_acronym_id = #{options['rate']}

        UNION ALL
        	SELECT entities.id, name, identifications.value, NULL AS \"contract_id\", NULL AS \"fees_id\"
        	FROM entities
        	LEFT JOIN identifications ON identifications.entity_id = entities.id
        	WHERE entities.id NOT IN (
        		SELECT entities.id
        		FROM entities
        		LEFT JOIN identifications ON identifications.entity_id = entities.id
        		LEFT JOIN contracts ON contracted_entity_id = entities.id
        		LEFT JOIN fees ON fees.contract_id = contracts.id
        		WHERE
        			(identifications.name_acronym_id = 100001 OR identifications.name_acronym_id = 100002)
            	AND name ~* '#{options['name']}'
            	AND fees.coin_id = '#{options['coin_id']}'
            	AND fees.name_acronym_id = #{options['rate']}
        	)

        ORDER BY name;
      ")
    rescue => ex
      return {error: true, info: 4, exception: ex}
    end

    return {error: false, results: entities}
  end
end