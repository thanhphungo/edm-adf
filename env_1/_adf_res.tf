# Linked Service
resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "adf_dl" {
  count                = var.deployment_conditions.adf == "yes" ? 1 : 0
  name                 = "linked_dl"
  data_factory_id      = module.adf[0].adf_id
  url                  = module.dl[0].sa_primary_dfs_endpoint
  use_managed_identity = true
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "adf_sa" {
  count                = var.deployment_conditions.adf == "yes" ? 1 : 0
  name                 = "linked_sa"
  data_factory_id      = module.adf[0].adf_id
  service_endpoint     = module.sa[0].sa_primary_blob_endpoint
  use_managed_identity = true
}

# Dataset
resource "azurerm_data_factory_dataset_azure_blob" "sa_1" {
  count               = var.deployment_conditions.adf == "yes" ? 1 : 0
  name                = "ds_sa_1"
  data_factory_id     = module.adf[0].adf_id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.adf_sa[0].name
  path                = "test"
  description         = "Dataset for Blob Storage"
}

resource "azurerm_data_factory_custom_dataset" "dl_1" {
  count           = var.deployment_conditions.adf == "yes" ? 1 : 0
  name            = "ds_dl_1"
  data_factory_id = module.adf[0].adf_id
  type            = "Binary"

  linked_service {
    name = azurerm_data_factory_linked_service_data_lake_storage_gen2.adf_dl[0].name
  }

  type_properties_json = <<JSON
{
  "location": {
    "fileSystem": "test",
    "type":"AzureBlobFSLocation"
  }
}
JSON

  description = "Dataset for Data Lake Storage Gen2"
}

# Pipeline
resource "azurerm_data_factory_pipeline" "pl_1" {
  count           = var.deployment_conditions.adf == "yes" ? 1 : 0
  name            = "pipeline_1"
  data_factory_id = module.adf[0].adf_id

  variables = {}

  activities_json = <<JSON
[
    {
        "name": "copy_sa_to_dl",
        "type": "Copy",
        "dependsOn": [],
        "policy": {
            "timeout": "0.12:00:00",
            "retry": 0,
            "retryIntervalInSeconds": 30,
            "secureOutput": false,
            "secureInput": false
        },
        "userProperties": [],
        "typeProperties": {
            "source": {
                "type": "BlobSource",
                "recursive": true
            },
            "sink": {
                "type": "BinarySink",
                "storeSettings": {
                    "type": "AzureBlobFSWriteSettings"
                }
            },
            "enableStaging": false
        },
        "inputs": [
            {
                "referenceName": "ds_sa_1",
                "type": "DatasetReference"
            }
        ],
        "outputs": [
            {
                "referenceName": "ds_dl_1",
                "type": "DatasetReference"
            }
        ]
    }
]
JSON

  depends_on = [
    azurerm_data_factory_dataset_azure_blob.sa_1,
    azurerm_data_factory_custom_dataset.dl_1
  ]
}

# Trigger
resource "azurerm_data_factory_trigger_blob_event" "tr_1" {
  count                 = var.deployment_conditions.adf == "yes" ? 1 : 0
  name                  = "trigger_1"
  data_factory_id       = module.adf[0].adf_id
  storage_account_id    = module.sa[0].sa_id
  events                = ["Microsoft.Storage.BlobCreated"]
  blob_path_begins_with = "/test/blobs/test_"
  blob_path_ends_with   = ".txt"
  ignore_empty_blobs    = true
  activated             = true

  annotations = []
  description = "Trigger for Blob Storage"

  pipeline {
    name       = azurerm_data_factory_pipeline.pl_1[0].name
    parameters = {}
  }

  additional_properties = {}
}
