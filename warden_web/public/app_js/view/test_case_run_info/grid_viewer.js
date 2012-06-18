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
      { header: 'Scenario', xtype: 'templatecolumn', flex: 1,
        tpl: "<a href='/test_case_run_info/show_log?id={id}' target='_blank'>{name}</a>"
      },
      { header: 'Started at', dataIndex: 'start_at', flex: 1},
      { header: 'Screen Capture', dataIndex: 'screen_capture_links', flex: 1,
        renderer: function(value) {
          var html_links = '';
          var screen_capture_links = Ext.JSON.decode(value);
          if(screen_capture_links){
            for( var i = 0; i < screen_capture_links.length; i++ ){
              html_links += '<a target="_" href="' + screen_capture_links[i].url + '"> Image </a>';
            }
          }
          return html_links;
        }
      },
      { header: 'Status', dataIndex: 'status', flex: 1 },

    ];
    this.callParent(arguments);
  }
});

