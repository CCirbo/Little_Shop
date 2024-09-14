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


  describe "Create New Item" do 
    it 'can create a new item' do
      item_params = {
      name: "New Item",
      description: "A cool new item",
      unit_price: 49.99,
      merchant_id: 1
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      Merchant.create!(id: 1, name: "Test Merchant")

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      puts response.status
      puts response.body

      created_item = Item.last

      expect(response).to be_successful

      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])

      item = JSON.parse(response.body, symbolize_names: true)[:data]

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

  describe "Price low to high" do 
    it 'returns all items by price(Low to High)' do 
      Merchant.create!(id: 1, name: "Test Merchant")
      Item.create!(name: "Mouse", description: "Clicks", unit_price:100.99 , merchant_id:1)
      Item.create!(name: "Keyboard", description: "Types", unit_price:10.99 , merchant_id:1)
      Item.create!(name: "Pad", description: "Soft", unit_price:120.99 , merchant_id:1)
      Item.create!(name: "Notebook", description: "Gets Written On", unit_price:121.99 , merchant_id:1)
      
      get "/api/v1/items?sorted=price" 

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful

      prices = items.map { |item| item[:attributes][:unit_price] }
    
      expect(prices).to eq(prices.sort)

    end
  end


    it 'deletes the item and associated records, returns 204 no content' do

      merchant = Merchant.create!(name: "Test Merchant")
      item = merchant.items.create!(name: "Test Item", description: "This is a test item", unit_price: 100.0)
      invoice = Invoice.create!(merchant: merchant, customer: Customer.create!(first_name: "John", last_name: "Doe"), status: "shipped")
      invoice_item = InvoiceItem.create!(item: item, invoice: invoice, quantity: 1, unit_price: item.unit_price)


      expect(Item.count).to eq(1)
      expect(InvoiceItem.count).to eq(1)
      expect(Invoice.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_empty

      expect(Item.count).to eq(0)
      expect(InvoiceItem.count).to eq(0)
      expect(Invoice.count).to eq(1) 

      expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { InvoiceItem.find(invoice_item.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end



