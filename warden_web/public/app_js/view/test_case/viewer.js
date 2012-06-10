Ext.define('WardenWeb.view.test_case.viewer', {
  extend: 'Ext.grid.Panel',
  alias: 'widget.test_case_viewer',
  title: 'Test Case Viewer',
  initComponent: function() {
    this.store = 'test_cases';
    this.multiSelect = true;
    this.tbar = [
      { xtype: 'test_case_search_bar' },
      {
        xtype: 'textfield',
        emptyText: "Please enter a job name.",
        name: 'job_name',
        fieldLabel: 'Job Name'
      },
      {
        xtype: 'combo',
        store: 'app_envs',
        name: 'app_env',
        fieldLabel: 'Environment',
        displayField: 'env_display',
        valueField: 'env',
        editable: false,
        queryMode: 'local'
      },
      { xtype: 'button', text: 'Run', action: 'run_test_cases' }
    ];
    this.dockedItems = [{
        xtype: 'pagingtoolbar',
        store: 'test_cases',
        dock: 'bottom',
        displayInfo: true
    }];
    this.columns = [
      { header: 'TC_ID', dataIndex: 'tc_id', width: 50 },
      { header: 'Project', dataIndex: 'project_name', flex: 1 },
      { header: 'Feature', dataIndex: 'feature_name', flex: 1 },
      { header: 'Scenario', dataIndex: 'name', flex: 1 },
      { header: 'Register at', dataIndex: 'register_at', flex: 1 },

    ];
    this.callParent(arguments);
  }
});
