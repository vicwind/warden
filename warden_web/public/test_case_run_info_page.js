Ext.Loader.setConfig({enabled:true});
Ext.Loader.setPath('Ext', '../extjs-4.0.7/src');

Ext.application({
  name: 'WardenWeb',
  appFolder: '../app_js',
  controllers: ['test_case_run_info'],
  models: ['test_case', 'test_case_folder', 'test_run_job', 'test_case_run_info'],
  stores: ['test_cases', 'test_case_folders', 'test_run_jobs','test_case_run_infos'],
  launch: function() {
    Ext.create('Ext.container.Viewport',{
      layout: 'border',
      items: [
        {
          region: 'center',
          xtype: 'test_case_run_info_grid_viewer',
          margin: '25 5 5 5'
        }
      ]
    });
  }
});
