module Expenses
  class Creator
    def initialize(params)
      @params = params
      @account = ::Account.find(params[:account_id])
    end

    def perform
      Expense.transaction do
        Accounts::BalanceUpdater.new(account, params[:amount].to_i).decrease
        Expense.create!(params)
      end
    end

    private

    attr_reader :params, :account
  end
end
