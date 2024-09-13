require 'rails_helper'

RSpec.configure do |config| 
 config.formatter = :documentation 
end

 RSpec.describe "Items endpoints" do
  it "can send a list of items" do
    Merchant.create!(id: 1, name: "Test Merchant")
    Merchant.create!(id: 2, name: "Test Merchant")
    Merchant.create!(id: 3, name: "Test Merchant")
    Merchant.create!(id: 4, name: "Test Merchant")
    Item.create!(name: "Mouse", description: "Clicks", unit_price:100.99 , merchant_id:1)
    Item.create!(name: "Keyboard", description: "Types", unit_price:10.99 , merchant_id:2)
    Item.create!(name: "Pad", description: "Soft", unit_price:120.99 , merchant_id:3)
    Item.create!(name: "Notebook", description: "Gets Written On", unit_price:120.99 , merchant_id:4)

    get "/api/v1/items"
    
    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    items.each do |item|

      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)

      expect(item).to have_key(:attributes)
      attributes = item[:attributes]
      
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)

      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)

      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_a(Integer)
    end
  end
   
    describe "Fetch one item" do
      it "can get one item by its id" do
        Merchant.create!(id: 1, name: "Test Merchant")
        id = Item.create!(name: "Mouse", description: "Clicks", unit_price:100.99 , merchant_id:1).id
        get "/api/v1/items/#{id}"
        item1 = JSON.parse(response.body, symbolize_names: true)[:data]
      
        expect(response).to be_successful  
        expect(item1[:type]).to eq("item")
        expect(item1).to have_key(:type)
        expect(item1[:type]).to be_a(String)
  
        expect(item1).to have_key(:id)
        expect(item1[:id]).to be_an(String)

        attributes = item1[:attributes]
        expect(item1).to have_key(:attributes)
  
        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)
  
        expect(attributes).to have_key(:description)
        expect(attributes[:description]).to be_a(String)
  
        expect(attributes).to have_key(:unit_price)
        expect(attributes[:unit_price]).to be_a(Float)
         
        expect(attributes).to have_key(:merchant_id)
        expect(attributes[:merchant_id]).to be_a(Integer)
      end
    end

    describe "Update New Item" do
      it "can update an existing item" do
        Merchant.create!(id: 1, name: "Test Merchant")
        id = Item.create!(name: "Mouse", description: "Clicks", unit_price:100.99 , merchant_id:1).id
        previous_name = Item.last.name
        item_params = {name: "Tray"}
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
        updated_item = Item.find_by(id: id)
  
        expect(response).to be_successful
        expect(updated_item.name).to_not eq(previous_name)
        expect(updated_item.name).to eq("Tray")

      end
    end

end