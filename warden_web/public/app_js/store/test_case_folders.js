Ext.define('WardenWeb.store.test_case_folders',{
  extend: 'Ext.data.TreeStore',
  model: 'WardenWeb.model.test_case_folder',
  proxy: {
    type: 'ajax',
    url: '/test_case/extjs_tree.json',
    reader: {
     type: 'json'
    }
  },
  root:{
    id:'root_node',
    nodeType:'async',
    text:'Test case folder'
  }
  // root: {
  //   expanded: true,
  //   text: "My Root",
  //   children: [
  //     { text: "Test Project1", leaf: true, checked: true },
  //     { text: "Test Project2", expanded: true, checked: true, children: [
  //       { text: "cool.feature", leaf: true, checked: true}
  //     ] }
  //   ]
  // }
 // root: {expanded: true, text: "", "data": []}
  // root:
  //   {"expanded":true,"text":"Test case folder","children":[{"text":"test_active_resource_0","children":[{"text":"test case 1","leaf":true},{"text":"test case 2","leaf":true},{"text":"test case 3","leaf":true},{"text":"test case 4","leaf":true},{"text":"test case 5","leaf":true},{"text":"test case 6","leaf":true},{"text":"test case 9","leaf":true},{"text":"test case 10","leaf":true}],"checked":true},{"text":"test_active_resource_1","children":[{"text":"test case 7","leaf":true},{"text":"test case 8","leaf":true}],"checked":true}]}
})
