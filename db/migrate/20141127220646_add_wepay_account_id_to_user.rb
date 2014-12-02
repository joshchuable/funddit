class AddWepayAccountIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :wepay_account_id, :integer
  end
end
