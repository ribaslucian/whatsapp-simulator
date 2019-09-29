class Enables < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'uuid-ossp'

    execute File.read('db/migrate/sql/enables.sql');
  end
end
