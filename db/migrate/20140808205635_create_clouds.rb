class CreateClouds < ActiveRecord::Migration
  def change
    create_table :clouds do |t|
      t.string :name
      t.string :instance_id
      t.datetime :turn_off_at
      t.string :ami_id
      t.string :subnet_id
      t.references :account

      t.timestamps
    end
    add_index :clouds, :account_id
  end
end
