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
end
