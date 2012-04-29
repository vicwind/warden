Ext.define('WardenWeb.store.app_envs', {
  extend: 'Ext.data.Store',
  model: 'WardenWeb.model.app_env',
  data: [
    { env_display: 'Production', env: 'prd' },
    { env_display: 'Development', env: 'development' },
    { env_display: 'Staging', env: 'staging' },
    { env_display: 'QA', env: 'qa' }
  ]

})
