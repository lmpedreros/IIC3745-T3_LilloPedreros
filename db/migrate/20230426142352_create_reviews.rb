class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.string :tittle
      t.string :description
      t.string :calification
      t.belongs_to :product
      t.timestamps
    end
  end
end
