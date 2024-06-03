class UpdateUsersDeseados < ActiveRecord::Migration[7.0]
  def change
    User.where(deseados: nil).update_all(deseados: [])
  end
end
