Ext.define('WardenWeb.view.test_case_run_info.grid_viewer', {
  extend: 'Ext.grid.Panel',
  alias: 'widget.test_case_run_info_grid_viewer',
  title: 'Test Case Run Info Viewer',
  initComponent: function() {
    this.store = 'test_case_run_infos';
    this.multiSelect = true;
    this.dockedItems = [{
        xtype: 'pagingtoolbar',
        store: 'test_case_run_infos',
        dock: 'bottom',
        displayInfo: true
    }];
    this.columns = [
      { header: 'TC_ID', dataIndex: 'tc_id', width: 50 },
      { header: 'Project', dataIndex: 'project_name', flex: 1 },
      { header: 'Feature', dataIndex: 'feature_name', flex: 1 },
      { header: 'Scenario', dataIndex: 'name', flex: 1 },
      { header: 'Status', dataIndex: 'status', flex: 1 },

    ];
    this.callParent(arguments);
  }
});

