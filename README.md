# Azure CosmosDB
Terraform module that provisions a CosmosDB and Database on Azure then create container with attributes of Autoscale, Maximum Througput and integrated private endpoint.

## Usage
You can include the module by using the following code:

```
provider "azurerm" {
  
  features {}

}
# Resource Group Module
module "rg" {
  source = "git::git@ssh.dev.azure.com:v3/AZBlue/OneAZBlue/terraform.devops.resource-group?ref=v0.0.5"

  info = var.info
  tags = var.tags

  location = var.location
}

# CosmosDB Module
module "cosmos_db" {
  source = "git::git@ssh.dev.azure.com:v3/AZBlue/OneAZBlue/terraform.devops.cosmos-db?ref=v1.0.0"
  
  info = var.info
  tags = var.tags
  
  # Resource Group
  resource_group_name  = module.rg.name
  location             = var.location
  
  # CosmosDB Database Name
  database_name        = var.database_name
  container_attributes = var.container_attributes
  max_throughput       = var.max_throughput

  # Firewall 
  subnet_whitelist = var.subnet_whitelist

  private_endpoint         = var.private_endpoint
  private_endpoint_enabled = var.private_endpoint_enabled
  subresource_names        = var.subresource_names
  dns_resource_group_name  = var.dns_resource_group_name
}
```

## Inputs

The following are the supported inputs for the module.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| info | Info object used to construct naming convention for all resources. | `object` | n/a | yes |
| tags | Tags object used to tag resources. | `object` | n/a | yes |
| resource_group | Name of the resource group where the data factory will be deployed. | `string` | n/a | yes |
| database_name | Name of the database. | `string` | n/a | yes |
| location | Location of CosmosDB and database. | `string` | n/a | yes |

| failover_location | Failover Location for CosmosDB. | `string` | westus2 | no |
| network_filter | If you want to enable firewall for CosmosDB | `bool` | `true` | no |
| container_name |                                             | `string` | n/a | no |
| max_throughput | The throughput of SQL container (RU/s).The minimum value is 400 | `string` | n/a | no |
 
| subnet | Name of the subnet used to lookup the subnet ID for the virtual machine. | `string` | `vnD01sn112` | no |
| virtual_network | Name of the virtual network used to lookup the subnet ID for the virtual machine. | `string` | `vnetVelConD01` | no |
| private_endpoint | List of objects of the subnet information that private endpoint will be created.  | `list of object` | [] | yes, if private_endpoint_enabled |
| private_endpoint_enabled | Enable the private endpoint integration  | `bool` | `false` | no |
| subresource_names | List of subresource names  | `list` | n/a | yes, if private_endpoint_enabled |
| dns_resource_group_name | DNS resource group name | `string` | `hubvnetrg`