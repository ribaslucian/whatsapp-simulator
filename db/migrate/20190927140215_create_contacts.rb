class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts, id: :uuid do |t|

	    ## default fields
      t.timestamps

      ## relations
      t.belongs_to :entity, type: :uuid, foreign_key: {to_table: :entities, name: 'rule_fk:contacts.entities'}, null: false
      t.bigint :mean_acronym_id, foreign_key: {to_table: :acronyms, name: 'rule_fk:contacts.mean_acronym'}
      t.bigint :category_acronym_id, foreign_key: {to_table: :acronyms, name: 'rule_fk:contacts.category_acronym'}

      ## fields
      t.string :description
      t.string :value, limit: 96, null: false
      t.integer :priority, limit: 2, default: 1, null: false
      t.boolean :confirmed, default: false

      ## rules
      t.index [:entity_id, :value], unique: true, name: 'rule_unique:contacts.no_repeat_contact_for_entity'
    end

    execute 'ALTER TABLE contacts ADD COLUMN ids BIGSERIAL NOT NULL;
    CREATE UNIQUE INDEX "rule_unique:contacts.ids" ON contacts(ids);';
  end
end
