require "rails_helper"

RSpec.describe "Accounts", type: :request do
  describe "#index" do
    context "when there are no accounts" do
      it "returns a list of accounts" do
        get "/accounts"
        expect(json_body).to match_array([])
      end
    end

    context "when there are some accounts" do
      let!(:first_account) { FactoryBot.create(:account) }
      let!(:second_account) { FactoryBot.create(:account) }

      it "returns a list of accounts" do
        get "/accounts"
        expect(json_body.count).to eq(2)
        expect(json_body.first).to include("name" => first_account.name, "number" => first_account.number, "balance" => 1000)
      end
    end
  end
  
  describe "#show" do
    context "when there is no records with such id" do
      it "returns a not found error" do
        get "/accounts/999"
        expect(json_body).to eq("Couldn't find Account with 'id'=999")
        expect(response.code).to eq("404")
      end
    end

    context "when account exists with the provided id" do
      let!(:account) { FactoryBot.create(:account) }

      it "returns correct accounts" do
        get "/accounts/#{account.id}"
        expect(json_body).to include("name" => account.name, "number" => account.number, "balance" => 1000)
      end
    end
  end

  describe "#create" do
    context "when no params are passed" do
      it "returns validation error" do
        post "/accounts", params: {}
        expect(json_body).to eq({"name" => ["can't be blank"], "number" => ["can't be blank"]})
        expect(response.code).to eq("400")
      end
    end

    context "when number and name are passed" do
      let(:request_params) { { name: "test name", number: "test number"} }
      subject(:request) { post "/accounts", params: request_params }

      it "returns account information" do
        subject
        expect(json_body).to include({"name" => "test name", "number" => "test number", "balance" => 1000})
      end

      it "saves account in database" do
        subject
        expect(Account.last.attributes).to include({"name" => "test name", "number" => "test number", "balance" => 1000})
      end
    end

    context "when balance is passed" do
      let(:request_params) { { name: "test name", number: "test number", balance: 2000} }
      subject(:request) { post "/accounts", params: request_params }

      it "returns account without balance overrides" do
        subject
        expect(json_body).to include({"name" => "test name", "number" => "test number", "balance" => 1000})
      end

      it "saves account without balance overrides" do
        subject
        expect(Account.last.attributes).to include({"name" => "test name", "number" => "test number", "balance" => 1000})
      end
    end
  end

  describe "#update" do
    context "when there is no records with such id" do
      it "returns a not found error" do
        patch "/accounts/999", params: {}
        expect(json_body).to eq("Couldn't find Account with 'id'=999")
        expect(response.code).to eq("404")
      end
    end

    context "when account exists with the provided id" do
      let!(:account) { FactoryBot.create(:account) }

      context "when no params are passed" do
        subject(:request) { patch "/accounts/#{account.id}", params: {} }

        it "does not update the record" do
          expect { subject }.not_to change { Account.last }
        end

        it "returns correct response" do
          subject

          expect(json_body).to include({"name" => account.name, "number" => account.number, "balance" => 1000})
        end
      end

      context "when name is passed" do
        subject(:request) { patch "/accounts/#{account.id}", params: { name: "new name" } }

        it "updates the record in database" do
          expect { subject }.to change { Account.last.name }.to("new name")
        end

        it "returns correct response" do
          subject

          expect(json_body).to include({"name" => "new name", "number" => account.number, "balance" => 1000})
        end
      end

      context "when number is passed" do
        subject(:request) { patch "/accounts/#{account.id}", params: { number: "new number" } }

        it "updates the record in database" do
          expect { subject }.to change { Account.last.number }.to("new number")
        end

        it "returns correct response" do
          subject

          expect(json_body).to include({"name" => account.name, "number" => "new number", "balance" => 1000})
        end
      end

      context "when balance is passed" do
        subject(:request) { patch "/accounts/#{account.id}", params: { balance: 2000 } }

        it "does not update the record" do
          expect { subject }.not_to change { Account.last }
        end

        it "returns correct response" do
          subject

          expect(json_body).to include({"name" => account.name, "number" => account.number, "balance" => 1000})
        end
      end
    end
  end

  describe "#destroy" do
    context "when there is no records with such id" do
      it "returns a not found error" do
        delete "/accounts/999"
        expect(json_body).to eq("Couldn't find Account with 'id'=999")
        expect(response.code).to eq("404")
      end
    end

    context "when account exists with the provided id" do
      let!(:account) { FactoryBot.create(:account) }
      let!(:second_account) { FactoryBot.create(:account) }
      let!(:accounts_expense1) { FactoryBot.create(:expense, account: account) }
      let!(:accounts_expense2) { FactoryBot.create(:expense, account: account) }
      let!(:second_account_expense) { FactoryBot.create(:expense, account: second_account) }

      it "deletes account with related expenses" do
        delete "/accounts/#{account.id}"
        expect(Account.all.pluck(:id)).to eq([second_account.id])
        expect(Expense.all.pluck(:id)).to eq([second_account_expense.id])
      end
    end
  end
end
