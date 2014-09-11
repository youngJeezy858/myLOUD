class CreateEntitlements < ActiveRecord::Migration
  def change
    create_table :entitlements do |t|
      t.string :instance_id
      t.string :name
      t.string :ip_address
      t.string :status
      t.timestamp :shutoff
      t.string :ami
      t.integer :account_id

      t.timestamps
    end
  end
end
