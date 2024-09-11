class Invoice < ApplicationRecord
    belongs_to :customer
    belongs_to :merchant
    has_many :invoice_item
    has_many :transaction
end