require "rails_helper"

RSpec.describe 'Expense' do           
  describe 'validation' do
    let!(:account) { FactoryBot.create(:account) }

    context 'when all conditions are met' do
      let!(:expense) { FactoryBot.build(:expense, account: account, description: 'transaction name', amount: 200, date: Time.current)}

      it 'saves record without errors' do
        expense.save!
        expect(Expense.last.attributes).to include("description" =>'transaction name', "amount" => 200, "account_id" => account.id)
      end
    end

    context 'when amount is empty' do
      let!(:expense) { FactoryBot.build(:expense, amount: nil)}

      it 'raises validation error' do
        expect{ expense.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when amount is 0' do
      let!(:expense) { FactoryBot.build(:expense, amount: 0)}

      it 'raises validation error' do
        expect{ expense.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when amount is negative' do
      let!(:expense) { FactoryBot.build(:expense, amount: -10)}

      it 'raises validation error' do
        expect{ expense.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when description is empty' do
      let!(:expense) { FactoryBot.build(:expense, description: nil)}

      it 'raises validation error' do
        expect{ expense.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when no associated account' do
      let!(:expense) { FactoryBot.build(:expense, account_id: nil)}

      it 'raises validation error' do
        expect{ expense.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when date is missing' do
      let!(:expense) { FactoryBot.build(:expense, date: nil)}

      it 'raises validation error' do
        expect{ expense.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
