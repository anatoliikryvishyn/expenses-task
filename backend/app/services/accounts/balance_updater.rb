module Accounts
  class BalanceUpdater
    def initialize(account, amount)
      @account = account
      @amount = amount
    end

    def increase
      account.balance += amount
      account.save!
    end

    def decrease
      raise NegativeBalanceError if negative_balance?

      account.balance -= amount
      account.save!
    end

    private

    attr_reader :account, :amount

    class NegativeBalanceError < StandardError
      def message
        "Balance can't be negative"
      end
    end

    def negative_balance?
      account.balance < amount
    end	
  end
end
