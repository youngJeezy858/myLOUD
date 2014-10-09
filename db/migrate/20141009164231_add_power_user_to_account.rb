class AddPowerUserToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :power_user, :boolean, :default => false
  end
end
