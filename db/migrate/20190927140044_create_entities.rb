class CreateEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :entities, id: :uuid do |t|

      ## default fields
      t.timestamps

      ## relations
      t.bigint :gender_acronym_id, foreign_key: {to_table: :acronyms, name: 'rule_fk:entities.gender_acronym'}

      ## fields
      t.string :name, limit: 96, null: false # name is fantasy name for corporations
      t.boolean :legal, default: false, null: false
    end

     execute 'ALTER TABLE entities ADD COLUMN ids BIGSERIAL NOT NULL;
     CREATE UNIQUE INDEX "rule_unique:entities.ids" ON entities(ids);';
  end
end
