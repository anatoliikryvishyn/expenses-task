class Account < ApplicationRecord
  has_many :expenses, dependent: :destroy

  validates :name, :number, :balance, presence: true
  validates :balance, numericality: { only_integer: true }
end
