class Customer < ApplicationRecord
    has_many :invoices
    has_many :merchants, through: :invoices

    def self.for_merchant(merchant_id)
        joins(:invoices).where(invoices: { merchant_id: merchant_id }).distinct
    end
end