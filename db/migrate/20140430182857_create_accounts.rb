class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.integer :minutes, :default => 6000
      t.integer :instance_limit, :default => 2

      t.timestamps
    end
  end
end
