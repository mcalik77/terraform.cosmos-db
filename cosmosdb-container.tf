resource "azurerm_cosmosdb_sql_container" "cosmosdb_container" {
  
  for_each = {
    for index, attribute in var.container_attributes: index => attribute
  }

  name                = each.value.container_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.sql_db.name
  partition_key_path  = each.value.partition_key_path
  

}