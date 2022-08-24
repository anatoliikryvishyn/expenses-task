class Account < ApplicationRecord
  has_many :expenses, dependent: :destroy

  validates :name, :number, :balance, presence: true
  validates :balance, numericality: { greater_than: 0, only_integer: true }
end
