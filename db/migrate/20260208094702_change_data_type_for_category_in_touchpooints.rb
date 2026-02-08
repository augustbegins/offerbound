class ChangeDataTypeForCategoryInTouchpooints < ActiveRecord::Migration[8.0]
  def change
    remove_column :touchpoints, :category
    add_column :touchpoints, :category, :integer
  end
end 
