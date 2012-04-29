Ext.Loader.setConfig({enabled:true});
Ext.Loader.setPath('Ext', '../extjs-4.0.7/src');

Ext.application({
  name: 'WardenWeb',
  appFolder: '../app_js',
  controllers: ['test_cases', 'test_run_job'],
  models: ['test_case', 'test_case_folder', 'test_run_job'],
  stores: ['test_cases', 'test_case_folders', 'app_envs', 'test_run_jobs'],
  launch: function() {
    Ext.create('Ext.container.Viewport',{
      layout: 'border',
      items: [
        {
          region: 'center',
          xtype: 'test_run_job_viewer',
          margin: '25 5 5 5'
        }
      ]
    });
  }
});
