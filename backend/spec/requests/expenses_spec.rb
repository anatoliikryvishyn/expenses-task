require "rails_helper"

RSpec.describe "Expenses", type: :request do
  describe "#index" do
    context "when there are no expenses" do
      it "returns a list of expenses" do
        get "/expenses"
        expect(json_body).to match_array([])
      end
    end

    context "when there are some expenses" do
      let!(:first_expense) { FactoryBot.create(:expense) }
      let!(:second_expense) { FactoryBot.create(:expense) }

      it "returns a list of expenses" do
        get "/expenses"
        expect(json_body.count).to eq(2)
        expect(json_body.first).to include("amount" => first_expense.amount, "description" => first_expense.description, "account_id" => first_expense.account_id)
      end
    end
  end
  
  describe "#show" do
    context "when there is no records with such id" do
      it "returns a not found error" do
        get "/expenses/999"
        expect(json_body).to eq("Couldn't find Expense with 'id'=999")
        expect(response.code).to eq("404")
      end
    end

    context "when expense exists with the provided id" do
      let!(:expense) { FactoryBot.create(:expense) }

      it "returns correct accounts" do
        get "/expenses/#{expense.id}"
        expect(json_body).to include("amount" => expense.amount, "description" => expense.description, "account_id" => expense.account_id)
      end
    end
  end

  describe "#create" do
    let!(:account) { FactoryBot.create(:account) }

    context "when params are empty" do
      it "returns validation error" do
        post "/expenses", params: { }
        expect(json_body).to eq("Couldn't find Account without an ID")
        expect(response.code).to eq("404")
      end
    end

    context "when only account is passed" do
      it "returns validation error" do
        post "/expenses", params: { account_id: account.id }
        expect(json_body).to eq({"amount" => ["can't be blank", "is not a number"], "description" => ["can't be blank"], "date" => ["can't be blank"]})
        expect(response.code).to eq("400")
      end
    end

    context "when all params are passed" do
      let(:request_params) { { description: "test description", date: Time.current, account_id: account.id, amount: 200} }
      subject(:request) { post "/expenses", params: request_params }

      it "returns expense information" do
        subject
        expect(json_body).to include("amount" => 200, "description" => "test description", "account_id" => account.id)
      end

      it "saves expense in database" do
        subject
        expect(Expense.last.attributes).to include("amount" => 200, "description" => "test description", "account_id" => account.id)
      end

      it "decrease the balance of an account" do
        subject
        expect(account.reload.balance).to eq(800)
      end

      context "when amount is bigger then accounts balance" do
        let(:request_params) { { description: "test description", date: Time.current, account_id: account.id, amount: 1200} }

        it "returns error message" do
          subject
          expect(json_body).to eq("Account balance can't be negative")
        end
  
        it "does not save expense in database" do
          expect{ subject }.not_to change{ Expense.count }
        end
  
        it "does not change the balance of an account" do
          subject
          expect(account.reload.balance).to eq(1000)
        end
      end
    end
  end

  describe "#update" do
    context "when there is no records with such id" do
      it "returns a not found error" do
        patch "/expenses/999", params: {}
        expect(json_body).to eq("Couldn't find Expense with 'id'=999")
        expect(response.code).to eq("404")
      end
    end

    context "when expense exists with the provided id" do
      let!(:account) { FactoryBot.create(:account) }
      let!(:second_account) { FactoryBot.create(:account) }
      let!(:expense) { FactoryBot.create(:expense, account: account, amount: 200) }

      context "when no params are passed" do
        subject(:request) { patch "/expenses/#{expense.id}", params: {} }

        it "does not update the record" do
          expect { subject }.not_to change { Expense.last }
        end

        it "returns correct response" do
          subject

          expect(json_body).to include({"description" => expense.description, "amount" => expense.amount})
        end

        it "does not change the account balance" do
          subject
          expect(account.reload.balance).to eq(1000)
        end
      end

      context "when description is passed" do
        subject(:request) { patch "/expenses/#{expense.id}", params: { description: "new description" } }

        it "updates the record in database" do
          expect { subject }.to change { Expense.last.description }.to("new description")
        end

        it "returns correct response" do
          subject

          expect(json_body).to include({"description" => "new description", "amount" => expense.amount})
        end

        it "does not change the account balance" do
          subject
          expect(account.reload.balance).to eq(1000)
        end
      end

      context "when amount and account are changed" do
        subject(:request) { patch "/expenses/#{expense.id}", params: { amount: 500, account_id: second_account.id } }

        it "updates the account relation" do
          expect { subject }.to change { Expense.last.account_id }.from(account.id).to(second_account.id)
        end

        it "updates amount" do
          expect { subject }.to change { Expense.last.amount }.from(200).to(500)
        end

        it "returns correct response" do
          subject

          expect(json_body).to include({"description" => expense.description, "amount" => 500, "account_id" => second_account.id})
        end

        it "updates accounts balance" do
          subject
          expect(account.reload.balance).to eq(1200)
          expect(second_account.reload.balance).to eq(500)
        end

        context "when target account has not enough money" do
          subject(:request) { patch "/expenses/#{expense.id}", params: { amount: 1200, account_id: second_account.id } }

          it "does not update the account relation" do
            expect { subject }.not_to change { Expense.last.account_id }
          end

          it "does not update the account relation" do
            expect { subject }.not_to change { Expense.last.account_id }
          end

          it "does not update amount" do
            expect { subject }.not_to change { Expense.last.amount }
          end

          it "does not update accounts balance" do
            subject
            expect(account.reload.balance).to eq(1000)
            expect(second_account.reload.balance).to eq(1000)
          end

          it "returns error message" do
            subject
            expect(json_body).to eq("Account balance can't be negative")
          end
        end
      end
    end
  end

  describe "#destroy" do
    context "when there is no records with such id" do
      it "returns a not found error" do
        delete "/expenses/999"
        expect(json_body).to eq("Couldn't find Expense with 'id'=999")
        expect(response.code).to eq("404")
      end
    end

    context "when expense exists with the provided id" do
      let!(:expense1) { FactoryBot.create(:expense) }
      let!(:expense2) { FactoryBot.create(:expense) }

      it "deletes expense" do
        delete "/expenses/#{expense1.id}"
        expect(Expense.all.pluck(:id)).to eq([expense2.id])
      end
    end
  end
end
