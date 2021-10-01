# Environment variables should be used for authentication.
#
# ARM_SUBSCRIPTION_ID
# ARM_CLIENT_ID
# ARM_CLIENT_SECRET
# ARM_TENANT_ID
#
# Reference the Azure Provider documentation for more information.
variable info {
  type = object({
    domain      = string
    subdomain   = string
    environment = string
    sequence    = string
  })

  description = "Info object used to construct naming convention for all resources."
}

variable tags {
  type        = map(string)
  description = "Tags object used to tag resources."
}

# Resource Group
variable resource_group_name {}
variable location {}

# CosmosDB Database 
variable database_name{}

variable failover_location {
    default = "westus2"
}

variable ip_range {
    default = "204.153.155.151,104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26"
}
variable network_filter {
    default = true
}

variable cosmosdb_offer_type {
    default = "Standard"
}

variable cosmosdb_kind {
    default = "GlobalDocumentDB"
}

variable cosmosdb_consistency_level {
    default = "Session"
}

#cosmosdb container attributes
variable "container_attributes" {
 type = list(object({
   container_name     = string
   partition_key_path = string
  }
))
}    

variable max_throughput {}

variable "subnet_whitelist" {
 type = list(object({
   virtual_network_name                = string
   virtual_network_subnet_name         = string
   virtual_network_resource_group_name = string
  }
))
} 

variable private_endpoint_subnet{
  type = object (
    {
      virtual_network_name                = string
      virtual_network_subnet_name         = string
      virtual_network_resource_group_name = string
    }
  )

  default = {
    virtual_network_name                = null
    virtual_network_subnet_name         = null
    virtual_network_resource_group_name = null
  }
}

variable private_endpoint_enabled {
  type    = bool
  default = true
}
variable subresource_names {
  type = list
  default = ["Sql"]
}
