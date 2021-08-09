class RemoveAmountFromIngredient < ActiveRecord::Migration[6.1]
  def change
    remove_column :ingredients, :amount, :integer
  end
end
