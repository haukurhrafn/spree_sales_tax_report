# add the sales tax report
Spree::Admin::ReportsController.add_available_report!(:sales_tax)


Spree::Admin::ReportsController.class_eval do 
  def sales_tax
    raise 't'
  end
end