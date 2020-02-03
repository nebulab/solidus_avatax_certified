# frozen_string_literal: true

Spree::LineItem.class_eval do
  def to_hash
    {
      'Index' => id,
      'Name' => name,
      'ItemID' => sku,
      'Price' => price.to_s,
      'Qty' => quantity,
      'TaxCategory' => tax_category
    }
  end

  def avatax_cache_key
    key = ['Spree::LineItem']
    key << id
    key << quantity
    key << price
    key << promo_total
    key.join('-')
  end

  def avatax_line_code
    'LI'
  end
end
