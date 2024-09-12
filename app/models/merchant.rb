class Merchant < ApplicationRecord
    has_many :items
    has_many :invoices

    def returned_items(status)
        # items.where(status: status) means = returned
    end
end

