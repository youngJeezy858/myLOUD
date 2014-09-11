class AddSecurityGroupIdToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :security_group_id, :string
  end
end
