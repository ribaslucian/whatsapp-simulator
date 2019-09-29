class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|

      ## default fields
      t.timestamps

      ## relations
      t.belongs_to :entity, type: :uuid, foreign_key: {to_table: :entities, name: 'rule_fk:users.entities'}, index: {unique: true, name: 'rule_unique:users.entity_id'}, null: false

      ## fields
      # t.string :hierarchy, limit: 32, default: 'holder' # merchant, contractor
      t.boolean :blocked, default: false, null: false
      t.string :password_raw, limit: 32
      t.string :password_sha1, limit: 40
      t.string :password_md5, limit: 32

      # recoverable
      t.uuid :reset_password_token, index: {unique: true, name: 'rule_unique:users.reset_password_token'}
      t.datetime :reset_password_sent_at
    end

    execute 'ALTER TABLE users ADD COLUMN ids BIGSERIAL NOT NULL;
    CREATE UNIQUE INDEX "rule_unique:users.ids" ON users(ids);';
  end
end
