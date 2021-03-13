class AddUserToBins < ActiveRecord::Migration[6.0]
  def change
    add_reference :bins, :user, null: false, foreign_key: true
  end
end
