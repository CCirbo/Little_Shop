class Item < ApplicationRecord
    belongs_to :merchant
    has_many :invoice_items, dependent: :destroy

    def self.sorted_by_price
        order(:unit_price)
    end

    def self.sort_and_filter(params)
        if params[:name] && (params[:min_price] || params[:max_price])
            raise ArgumentError.new("Cannot search by both name and price")
        end

        if params[:min_price] && params[:min_price].to_f < 0
            raise ArgumentError.new("min_price must be a positive number")
        elsif params[:max_price] && params[:max_price].to_f < 0
            raise ArgumentError.new("max_price must be a positive number")
        end

        items = all
        items = items.filter_by_name(params[:name]) if params[:name]
        items = items.filter_by_min(params[:min_price]) if params[:min_price]
        items = items.filter_by_max(params[:max_price]) if params[:max_price]

        items
    end

    def self.find_one_by_name(name)
        self.where("name ILIKE '%#{name}%'").order(:name).first
    end
    
    def self.filter_by_name(name)
        self.where("name ILIKE '%#{name}%'")
    end

    def self.filter_by_min(min_price)
        self.where("unit_price >= #{min_price}")
    end

    def self.filter_by_max(max_price)
        self.where("unit_price <= #{max_price}")
    end
end