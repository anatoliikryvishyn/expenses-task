class AccountsController < ApplicationController
  def index
    render json: Account.order(date: :desc)
  end

  def show
    render json: account
  end

  def create
    account = Accounts::Creator.new(account_params).perform

    render json: account
  end

  def update
    account.update!(account_params)

    render json: account
  end

  def destroy
    account.destroy
  end

  private

  def account_params
    params.permit(:name, :number)
  end

  def account
    account ||= Account.find(params[:id])
  end
end
