Ext.Loader.setConfig({enabled:true});
Ext.Loader.setPath('Ext', '../extjs-4.0.7/src');

Ext.application({
  name: 'WardenWeb',
  appFolder: '../app_js',
  controllers: ['test_cases'],
  models: ['test_case', 'test_case_folder'],
  stores: ['test_cases', 'test_case_folders', 'app_envs'],
  launch: function() {
    //Ext.Msg.alert("asdf");
    Ext.create('Ext.container.Viewport',{
      layout: 'border',
      items: [
        {
          region: 'center',
          xtype: 'test_case_viewer',
          margin: '0 5 30 0'
        },
        {
          region: 'west',
          width: 200,
          xtype: 'test_case_folder_viewer',
          split: true,
          collapsible: true,
          margin: '0 0 30 5'
        }
      ]
    });
  }
});
