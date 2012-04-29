Ext.define('WardenWeb.view.test_run_job.viewer', {
  extend: 'Ext.grid.Panel',
  alias: 'widget.test_run_job_viewer',
  title: 'Job Status',
  initComponent: function() {
    this.store = 'test_run_jobs';
    this.columns = [
      { header: 'Name', dataIndex: 'name', flex: 1},
      { header: 'Schedule at', dataIndex: 'schedule_at', flex: 1},
      { header: 'Queue Name', dataIndex: 'queue_name', flex: 1},
      { header: 'Running On', dataIndex: 'run_node', flex: 1},
      { header: 'Run Status ', dataIndex: 'status', flex: 1}
    ];

    this.callParent(arguments);
  }

});
