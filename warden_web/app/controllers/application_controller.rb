class ApplicationController < ActionController::Base
  LARGE_NUM = 99999999999

  protect_from_forgery

  protected
  def parse_pagenation_and_sorting_params
    @limit = params[:limit] || LARGE_NUM
    @offset = params[:start] || 0

    sort_params = ActiveSupport::JSON.decode(params[:sort]).first if params[:sort]
    sort_params['property'] = "warden_projects.name" if sort_params and sort_params['property'] == "project_name"
    sort_params['property'] = "test_cases.feature_name" if sort_params and sort_params['property'] == "feature_name"
    sort_params['property'] = "test_cases.tc_id" if sort_params and sort_params['property'] == "tc_id"
    sort_params['property'] = "test_cases.name" if sort_params and sort_params['property'] == "name" and
      params[:controller] == 'test_case_run_info'
    @sort_order =
      sort_params.nil? ? '' : "#{sort_params['property']} #{sort_params['direction']}"

  end

  #adding filtering condition to the model passed in, it will return a model
  #with proper conditions imposed
  def parse_filter_params(model, options = {})

    options.reverse_merge({filter_chaining: "OR", filter_type: 'like'})
    filters_params =  ActiveSupport::JSON.decode(params[:filter]) if params[:filter]
    compare_operator = options[:filter_type] == 'like' ? 'like' : '='
    filters_params ||= []
    condition_str = ''
    condition_values = []
    filters_params.each do |filter_params|
      condition_str += "#{filter_params['property']} #{compare_operator} ? #{options[:filter_chaining]} "
      filter_value = (compare_operator == 'like') ? "%#{filter_params['value']}%" : filter_params['value']
      condition_values << filter_value
    end
    condition_str.sub!(/ #{options[:filter_chaining]} $/,'')

    model.where(condition_str, *condition_values )
  end
end
