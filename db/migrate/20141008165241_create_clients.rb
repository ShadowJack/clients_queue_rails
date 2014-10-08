class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :operation, limit: 2
      t.integer :start, limit: 1
      t.integer :length, limit: 1
      t.integer :finish, limit: 1
      t.string :window, limit: 1

      t.timestamps
    end
  end
end
