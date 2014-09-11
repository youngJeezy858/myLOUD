class AddSecurityGroupIdToEntitlement < ActiveRecord::Migration
  def change
    add_column :entitlements, :security_group_id, :string
  end
end
