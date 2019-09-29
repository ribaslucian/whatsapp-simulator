class CreateIdentifications < ActiveRecord::Migration[5.1]
  def change
    create_table :identifications, id: :uuid do |t|

	    ## default fields
      t.timestamps

      ## relations
      t.belongs_to :entity, type: :uuid, foreign_key: {to_table: :entities, name: 'rule_fk:identifications.entities'}, null: false
      t.bigint :type_acronym_id, foreign_key: {to_table: :acronyms, name: 'rule_fk:identifications.type_acronym'}, null: false

      ## fields
      t.string :value, limit: 128, null: false
      t.string :printed_name, limit: 64
      t.timestamp :validity
      t.boolean :unique, default: true, null: false

      t.string :issuer, limit: 64
      t.timestamp :issuer_date

      ## rules
      #t.index [:entity_id, :name_acronym_id], unique: true, name: 'rule_unique:identifications.one_identification_name_per_entity'
      t.index [:entity_id, :value], unique: true, name: 'rule_unique:identifications.one_identification_value_per_entity'
    end

    execute 'ALTER TABLE identifications ADD COLUMN ids BIGSERIAL NOT NULL;
    CREATE UNIQUE INDEX "rule_unique:identifications.ids" ON identifications(ids);';

    execute File.read('db/migrate/sql/identifications.sql');
  end
end
