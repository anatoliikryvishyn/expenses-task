module Expenses
  class Updater
    def initialize(expense, params)
      @expense = expense
      @params = params
    end

    def perform
      Expense.transaction do
        update_accounts_balance if account_changed? || amount_changed?

        expense.update!(params)
        expense
      end
    end

    private

    attr_reader :expense, :params

    def account_changed?
      params[:account_id] && params[:account_id] != expense.account_id
    end

    def amount_changed?
      params[:amount] && params[:amount] != amount_to_increase
    end

    def update_accounts_balance
      Accounts::BalanceUpdater.new(expense.account, amount_to_increase).increase
      Accounts::BalanceUpdater.new(target_account, amount_to_decrease).decrease
    end

    def target_account
      params[:account_id] ? ::Account.find(params[:account_id]) : expense.account
    end

    def amount_to_increase
      expense.amount
    end

    def amount_to_decrease
      (params[:amount] || expense.amount).to_i
    end
  end
end
