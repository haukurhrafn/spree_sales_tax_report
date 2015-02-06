# add the sales tax report
Spree::Admin::ReportsController.add_available_report!(:sales_tax, 'Sales Tax Report')


Spree::Admin::ReportsController.class_eval do 
  before_action :search_params, only: [:sales_tax]

  def sales_tax
    @search = Spree::Order.complete.ransack(params[:q])
    @orders = @search.result

    @adjustments = Spree::Adjustment.where("adjustable_type = 'Spree::Order' and created_at >= '#{params[:q][:completed_at_gt].to_s(:db)}' and created_at <= '#{params[:q][:completed_at_lt]}'")

    @totals = {}


    @totals['Gross Sales']   = @orders.sum(:item_total)
    @totals['Taxable Sales'] = @orders.select(&:has_additional_tax?).sum(&:item_total)
    @totals['Taxes Collected'] =  @orders.sum(:additional_tax_total)
    @totals['Adjustments'] = @adjustments.sum(:amount)

    # @adjustments = Spree::Adjustment.
    
    



  end

  private
  def search_params
    params[:q] = {} unless params[:q]

    if params[:q][:completed_at_gt].blank?
      params[:q][:completed_at_gt] = Time.zone.now.beginning_of_month
    else
      params[:q][:completed_at_gt] = Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
    end

    if params[:q] && !params[:q][:completed_at_lt].blank?
      params[:q][:completed_at_lt] = Time.zone.parse(params[:q][:completed_at_lt]).end_of_day rescue ""
    else
      params[:q][:completed_at_lt] = Time.now.end_of_month
    end

    params[:q][:s] ||= "completed_at desc"
  end

end