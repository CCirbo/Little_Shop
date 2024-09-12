class Merchant < ApplicationRecord
    has_many :items, dependent: :destroy
    has_many :invoices, dependent: :destroy
end


    # def returned_items(status)
    #     # items.where(status: status) means = returned
    # end