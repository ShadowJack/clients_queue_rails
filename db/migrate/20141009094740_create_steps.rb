class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.integer :step, limit: 2

      t.timestamps
    end
  end
end
