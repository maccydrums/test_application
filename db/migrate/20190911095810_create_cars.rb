class CreateCars < ActiveRecord::Migration[6.0]
  def change
    create_table :cars do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.boolean :favorite, null: false, default: false

      t.timestamps
    end
  end
end
