class RemoveImgFromProducts < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :img, type: :string
  end
end
