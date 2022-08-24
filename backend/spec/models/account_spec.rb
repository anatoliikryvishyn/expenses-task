require "rails_helper"

RSpec.describe 'Account' do           
  describe 'validation' do
    context 'when all conditions are met' do
      let!(:account) { FactoryBot.build(:account, name: 'account name', number: 'iban', balance: '2000')}

      it 'saves record without errors' do
        account.save!
        expect(Account.last.attributes).to include('name' => 'account name', 'number' => 'iban', 'balance' => 2000)
      end
    end

    context 'when name is empty' do
      let!(:account) { FactoryBot.build(:account, name: nil)}

      it 'raises validation error' do
        expect{ account.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when number is empty' do
      let!(:account) { FactoryBot.build(:account, number: nil)}

      it 'raises validation error' do
        expect{ account.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when balance is empty' do
      let!(:account) { FactoryBot.build(:account, balance: nil)}

      it 'raises validation error' do
        expect{ account.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when balance is negative' do
      let!(:account) { FactoryBot.build(:account, balance: -10)}

      it 'raises validation error' do
        expect{ account.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when balance is 0' do
      let!(:account) { FactoryBot.build(:account, balance: 0)}

      it 'saves record without errors' do
        account.save!
        expect(Account.last.attributes).to include('balance' => 0)
      end
    end
  end
end
