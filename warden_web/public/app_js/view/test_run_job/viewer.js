Ext.define('WardenWeb.view.test_run_job.viewer', {
  extend: 'Ext.grid.Panel',
  alias: 'widget.test_run_job_viewer',
  title: 'Job Status',
  initComponent: function() {
    this.store = 'test_run_jobs';
    this.columns = [
      {
        header: 'Name', xtype: 'templatecolumn', dataIndex: 'name', flex: 1,
        tpl: "<a href='/test_case_run_info?job_id={id}'>{name}</a>"
      },
      { header: 'Schedule at', dataIndex: 'schedule_at', flex: 1},
      { header: 'Queue Name', dataIndex: 'queue_name', flex: 1},
      { header: 'Run On', dataIndex: 'run_node', flex: 1},
      {
        header: 'Pass Rate', xtype: 'templatecolumn',
        tpl: "{pass_rate}%",
        flex: 1
      },
      {
        header: 'Passed/Failed/Total',
        xtype: 'templatecolumn',
        tpl: "{number_of_passed}/{number_of_failed}/{total_number_of_test_cases}",
        flex: 1
      },
      { header: 'Run Status ', dataIndex: 'status', flex: 1}
    ];
    this.dockedItems = [{
        xtype: 'pagingtoolbar',
        store: 'test_run_jobs',
        dock: 'bottom',
        displayInfo: true
    }];

    this.callParent(arguments);
  }

});
