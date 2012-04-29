.span12
  %h1.page-header Status as of #{Time.now.strftime("%m/%d/%Y")}
  #tabs

:javascript
  var production_store = Ext.create('Ext.data.JsonStore', 
  { fields: ['instance', 'failed', 'passed', 'id'],
    data: [ 
    #{
      @production_data.map { |data|
        "{ instance: '#{data["name"]}', failed: '#{data["failed"]}', passed: '#{data["passed"]}', id: '#{data["id"]}' },"
      }.join
    }
    ]
  });
        
  var staging_store = Ext.create('Ext.data.JsonStore', 
  { fields: ['instance', 'failed', 'passed', 'id'],
    data: [ 
    #{
      @staging_data.map { |data|
        "{ instance: '#{data["name"]}', failed: '#{data["failed"]}', passed: '#{data["passed"]}', id: '#{data["id"]}' },"
      }.join
    }
    ]
  });      
  
  var qa_store = Ext.create('Ext.data.JsonStore', 
  { fields: ['instance', 'failed', 'passed', 'id'],
    data: [ 
    #{
      @qa_data.map { |data|
        "{ instance: '#{data["name"]}', failed: '#{data["failed"]}', passed: '#{data["passed"]}', id: '#{data["id"]}' },"
      }.join
    }
    ]
  });      
    
%script{:type => "text/javascript", :src=>"app_js/scenario.js" }

