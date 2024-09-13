class Merchant < ApplicationRecord
    has_many :items, dependent: :destroy
    has_many :invoices, dependent: :destroy

    def self.sorted_by_age
        order(created_at: :desc)
    end
end


    