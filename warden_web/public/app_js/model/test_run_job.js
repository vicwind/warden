Ext.define('WardenWeb.model.test_run_job', {
  extend: 'Ext.data.Model',
  fields: [ 'id', 'app_environment', 'name', 'schedule_at', 'run_node', 'status', 'queue_name', 'number_of_failed', 'number_of_passed', 'total_number_of_test_cases', 'pass_rate' ]

});
