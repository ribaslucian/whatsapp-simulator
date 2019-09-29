class CreateAcronyms < ActiveRecord::Migration[5.2]
  def change
    create_table :acronyms, id: :bigserial do |t|

      ## default fields
      t.timestamps
      t.uuid :uuid, default: 'uuid_generate_v4()', index: {unique: true, name: 'rule_unique:acronyms.uuid'}, null: false

      ## fields
      t.string :name, limit: 64, index: {unique: true, name: 'rule_unique:acronyms.name'}, null: false
      t.text :description

      # table.column
      t.string :data_refer, limit: 64, null: false
    end
    
    execute 'ALTER TABLE acronyms ADD COLUMN ids BIGSERIAL NOT NULL;
    CREATE UNIQUE INDEX "rule_unique:acronyms.ids" ON acronyms(ids);';
  end
end
