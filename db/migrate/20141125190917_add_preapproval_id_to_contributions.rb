class AddPreapprovalIdToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :preapproval_id, :string
  end
end
