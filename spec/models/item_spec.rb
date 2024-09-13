require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
  end

  describe '#class methods' do 
    it 'returns all items by price(Low to High)' do 
      Merchant.create!(id: 1, name: "Test Merchant")
      item_1 = Item.create!(name: "Mouse", description: "Clicks", unit_price:100.99 , merchant_id:1)
      item_2 = Item.create!(name: "Keyboard", description: "Types", unit_price:10.99 , merchant_id:1)
      item_3 = Item.create!(name: "Pad", description: "Soft", unit_price:120.99 , merchant_id:1)
      item_4 = Item.create!(name: "Notebook", description: "Gets Written On", unit_price:121.99 , merchant_id:1)
   
      expected = [item_2, item_1, item_3, item_4]

      expect(Item.sorted_by_price).to eq(expected)
    end
  end
end