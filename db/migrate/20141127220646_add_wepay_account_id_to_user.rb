class AddWepayAccountIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :wepay_account_id_string, :string
  end
end
