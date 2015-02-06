Spree::Order.class_eval do

  def has_additional_tax?
    additional_tax_total > 0
  end

end