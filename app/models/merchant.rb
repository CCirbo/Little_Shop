class Merchant < ApplicationRecord
    has_many :item
    has_many :invoice
end