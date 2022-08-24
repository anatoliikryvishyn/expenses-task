class ExpensesController < ApplicationController
  def index
    render json: Expense.order(date: :desc)
  end

  def show
    render json: expense
  end

  def create
    expense = Expenses::Creator.new(expense_params).perform
    render json: expense
  end

  def update
    updated_expense = Expenses::Updater.new(expense, expense_params).perform
    render json: updated_expense
  end

  def destroy
    expense.destroy
  end

  private

  def expense_params
    params.permit(:amount, :date, :description, :account_id)
  end

  def expense
    @expense ||= Expense.find(params[:id])
  end
end
