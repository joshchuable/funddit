class AddWepayAccessTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :wepay_access_token, :string
  end
end
