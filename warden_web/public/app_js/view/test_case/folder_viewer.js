Ext.define('WardenWeb.view.test_case.folder_viewer',{
  extend: 'Ext.tree.Panel',
  alias: 'widget.test_case_folder_viewer',
  title: 'Test Case Folder',
  initComponent: function() {
    this.store = 'test_case_folders'
    this.rootVisible = false
    this.multiSelect = true
   // this.selType = 'checkboxmodel'
    this.callParent(arguments);
  }
});
