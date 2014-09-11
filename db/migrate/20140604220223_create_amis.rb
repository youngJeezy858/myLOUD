class CreateAmis < ActiveRecord::Migration
  def change
    create_table :amis do |t|
      t.string :imageId
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
