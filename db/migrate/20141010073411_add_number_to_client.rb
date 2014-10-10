class AddNumberToClient < ActiveRecord::Migration
  def change
    add_column :clients, :number, :integer, limit: 2
  end
end
