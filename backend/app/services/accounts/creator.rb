module Accounts
  class Creator
    def initialize(params)
      @params = params
      @balance = ENV.fetch('DEFAULT_ACCOUNT_BALANCE', 1000)
    end

    def perform
      Account.create!(params.merge(balance: balance))
    end

    private
    
    attr_reader :params, :balance
  end
end
