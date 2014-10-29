class AddTotalUsageToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :total_usage, :integer, :default => 0
  end
end
