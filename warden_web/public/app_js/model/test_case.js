Ext.define('WardenWeb.model.test_case', {
  extend: 'Ext.data.Model',
  fields: ['feature_name', 'name', 'feature_file_path', 'tc_id', 'register_at',
    { name: 'project_name', type: 'string', mapping: 'warden_project.name' }
  ]
});
