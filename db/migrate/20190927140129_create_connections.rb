class CreateConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :connections, id: :uuid do |t|

      ## default fields
      t.timestamps

      ## relations
      t.belongs_to :entity, type: :uuid, foreign_key: {to_table: :entities, name: 'rule_fk:connections.entities'}, null: false
      # t.belongs_to :application, type: :uuid, foreign_key: {to_table: :applications, name: 'rule_fk:connections.applications'}, null: false
      # t.platform ???

      ## fields
      t.string :ipv4_private, limit: 24
      t.string :ipv4_public, limit: 24
      t.string :ipv6_public, limit: 32
      t.string :mac, limit: 24
      t.string :os, limit: 32
      t.string :browser, limit: 96

      t.timestamp :date_logout
      t.timestamp :date_expiration, null: false

      ## rules
      # t.index [:entity_id, :date_logout], unique: true, name: 'rule_unique:connections.one_valid_connection_entity'
    end

    execute 'ALTER TABLE connections ADD COLUMN ids BIGSERIAL NOT NULL;
    CREATE UNIQUE INDEX "rule_unique:connections.ids" ON connections(ids);';

    execute File.read('db/migrate/sql/connections.sql');
  end
end
