class CreateCars < ActiveRecord::Migration[6.0]
  def change
    create_table :cars do |t|
      t.string :name
      t.string :description
      t.boolean :favorite

      t.timestamps
    end
  end
end
