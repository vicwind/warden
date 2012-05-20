Ext.define('WardenWeb.model.test_case_run_info', {
  extend: 'Ext.data.Model',
  fields: [ 'id', 'start_at', 'end_at', 'status', 'test_case_log', 'external_data',
    'number_of_steps', 'test_case',
    { name: 'feature_name', type: 'string', mapping: 'test_case.feature_name'},
    { name: 'name', mapping: 'test_case.name'},
    { name: 'feature_file_path', mapping: 'test_case.feature_file_path'},
    { name: 'tc_id', mapping: 'test_case.tc_id'},
    { name: 'project_name', mapping: 'test_case.warden_project.name'}
  ],

  belongs_to: 'test_case',
  belongs_to: 'test_run_job'
});
