resource "azurerm_cosmosdb_sql_database" "sql_db" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
 
  autoscale_settings {
    max_throughput = var.max_throughput
  }

 }