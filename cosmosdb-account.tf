provider "azurerm" {
  version = ">= 2.0.0"
  features {
    // key_vault {
    //   purge_soft_delete_on_destroy    = false
    //   recover_soft_deleted_key_vaults = true
    // }
  }
}

module naming {
  source  = "github.com/Azure/terraform-azurerm-naming?ref=df6a893e8581ae2078fc40f65d3b9815ef86ac3d"
  // version = "0.1.0"
  suffix  = [ "${title(var.info.domain)}${title(var.info.subdomain)}" ]
}


module private_endpoint {
  count = var.private_endpoint_enabled ? 1 : 0

  source = "git::git@ssh.dev.azure.com:v3/AZBlue/OneAZBlue/terraform.devops.private-endpoint?ref=v0.0.6"

  info = var.info
  tags = var.tags

  resource_group_name = var.resource_group_name
  location            = var.location

  resource_id         = azurerm_cosmosdb_account.cosmosdb.id
  subresource_names   = ["Sql"]

  private_endpoint_subnet = var.private_endpoint_subnet
}

data "azurerm_subnet" "subnet" {
  
  for_each = {
   for index, attribute in var.subnet_whitelist: index => attribute
  }

  name                 = each.value.virtual_network_subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.virtual_network_resource_group_name
  
  }

locals {
  merged_tags = merge(var.tags, {
    domain = var.info.domain
    subdomain = var.info.subdomain
  })
}
  
resource "azurerm_cosmosdb_account" "cosmosdb" {
  
  name = replace(
    format("%s%s%03d",
      lower(substr(
        module.naming.cosmosdb_account.name, 0, 
        module.naming.cosmosdb_account.max_length - 4
      )),
      lower(substr(title(var.info.environment), 0, 1)),
      title(var.info.sequence)
    ), "cosmos-", "cdb"
  )
  location                          = var.location
  resource_group_name               = var.resource_group_name
  offer_type                        = var.cosmosdb_offer_type
  kind                              = var.cosmosdb_kind 
  ip_range_filter                   = var.ip_range
  enable_automatic_failover         = true
  is_virtual_network_filter_enabled = var.network_filter

  tags = local.merged_tags
  
  consistency_policy {
    consistency_level = var.cosmosdb_consistency_level
  }
 
  geo_location {
    location          = var.failover_location
    failover_priority = 1
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  dynamic "virtual_network_rule" {
    for_each = data.azurerm_subnet.subnet

    content{
       id = virtual_network_rule.value.id
     }
  }
  
 
}