class AddSizeToAmi < ActiveRecord::Migration
  def change
    add_column :amis, :size, :string
  end
end
