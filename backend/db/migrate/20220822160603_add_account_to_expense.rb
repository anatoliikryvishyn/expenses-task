class AddAccountToExpense < ActiveRecord::Migration[6.0]
  def change
    add_reference :expenses, :account, index: true
  end
end
