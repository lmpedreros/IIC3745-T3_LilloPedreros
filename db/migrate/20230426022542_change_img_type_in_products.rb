class ChangeImgTypeInProducts < ActiveRecord::Migration[7.0]
  def change
    change_column :products, :img, :binary, using: 'img::bytea'
  end
end
