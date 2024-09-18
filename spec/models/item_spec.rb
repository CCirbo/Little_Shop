require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
  end
  
  describe "Item Class Methods" do 
    before(:each) do
      @merchant = Merchant.create!(name: "Test Merchant")
      @item_1 = Item.create!(name: "Mouse", description: "Clicks", unit_price: 100.99, merchant: @merchant)
      @item_2 = Item.create!(name: "Keyboard", description: "Types", unit_price: 10.99, merchant: @merchant)
      @item_3 = Item.create!(name: "Pad", description: "Soft", unit_price: 120.99, merchant: @merchant)
      @item_4 = Item.create!(name: "Notebook", description: "Gets Written On", unit_price: 121.99, merchant: @merchant)
    end

    it "returns all items sorted by price (low to high)" do 
      expected = [@item_2, @item_1, @item_3, @item_4]
      expect(Item.sorted_by_price).to eq(expected)
    end

    it "filters items by name" do
      expect(Item.filter_by_name("Mouse")).to eq([@item_1])
    end

    it "filters items by min_price" do
      expect(Item.filter_by_min(100)).to eq([@item_1, @item_3, @item_4])
    end

    it "filters items by max_price" do
      expect(Item.filter_by_max(100)).to eq([@item_2])
    end

    describe "Find One By Name" do
      before(:each) do
        @merchant = Merchant.create!(name: "Test Merchant")
        @item_1 = Item.create!(name: "Thing", description: "Thingy", unit_price: 1.99, merchant: @merchant)
        @item_2 = Item.create!(name: "Anything", description: "Anythingy", unit_price: 10.99, merchant: @merchant)
        @item_3 = Item.create!(name: "Nothing", description: "Nothingy", unit_price: 100.99, merchant: @merchant)
      end

      context "when there are multiple matches" do
        it "returns the 1st item in A-Z order with a case insensitive search" do
          result = Item.find_one_by_name("tHIng")
          expect(result.id).to eq(@item_2.id)
        end
      end

      context "when there are no matches" do
        it "returns nil" do
          result = Item.find_one_by_name("xxx")
          expect(result).to be_nil
        end
      end
    end

    it "raises an error when both name and price parameters are passed" do
      params = { name: "Mouse", min_price: 50 }
      expect { Item.sort_and_filter(params) }.to raise_error(ArgumentError, "Cannot search by both name and price")
    end

    it "raises an error when min_price is negative" do
      params = { min_price: -10 }
      expect { Item.sort_and_filter(params) }.to raise_error(ArgumentError, "min_price must be a positive number")
    end

    it "raises an error when max_price is negative" do
      params = { max_price: -5 }
      expect { Item.sort_and_filter(params) }.to raise_error(ArgumentError, "max_price must be a positive number")
    end

    describe "Sort_and_filter" do
      it "filters by name only" do
        params = { name: "Mouse" }
        expected = [@item_1]
        result = Item.sort_and_filter(params) 
    
        expect(result).to eq(expected)
      end
  
      it 'filters by min_price only' do
        params = { min_price: 100 }
        expected = [@item_1, @item_3, @item_4]
        result = Item.sort_and_filter(params) 
    
        expect(result).to eq(expected)
      end
    
      it 'filters by max_price only' do
        params = { max_price: 100 }
        expected = [@item_2]
        result = Item.sort_and_filter(params) 
    
        expect(result).to eq(expected)
      end
   
      it "Sad-Path raises an error when both name and price parameters are passed" do
        params = { name: "Pad", min_price: 50, max_price: 120 }
        expect { Item.sort_and_filter(params) }.to raise_error(ArgumentError, "Cannot search by both name and price")
      end
    end
  end
end