class CreateContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :contracts, id: :uuid do |t|

      ## default fields
      t.timestamps

      ## relations
      t.uuid :contractor_entity_id, type: :uuid, foreign_key: {to_table: :entities, name: 'rule_fk:protocols.contractor_entity'}, null: false
      t.uuid :contracted_entity_id, type: :uuid, foreign_key: {to_table: :entities, name: 'rule_fk:protocols.contracted_entity'}, null: false

      t.bigint :type_acronym_id, foreign_key: {to_table: :acronyms, name: 'rule_fk:contracts.type_acronym'}, null: false
      t.boolean :active, default: true, null: false
      
      t.timestamp :date_end

      # rules
      t.index [
        :contractor_entity_id, :contracted_entity_id, :type_acronym_id
      ], unique: true, name: 'rule_unique:contracts.one_type_per_entities'
    end

    execute 'ALTER TABLE contracts ADD COLUMN ids BIGSERIAL NOT NULL;
    CREATE UNIQUE INDEX "rule_unique:contracts.ids" ON contracts(ids);';

    execute File.read('db/migrate/sql/contracts.sql');
  end
end
