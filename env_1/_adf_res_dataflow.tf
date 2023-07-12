resource "azurerm_data_factory_data_flow" "df_1" {
  name            = "dataflow_1"
  data_factory_id = module.adf[0].adf_id

  source {
    name = "source1"

    flowlet {
      name = azurerm_data_factory_flowlet_data_flow.fl_df_1.name
      parameters = {
        "Key1" = "value1"
      }
    }

    dataset {
      name = azurerm_data_factory_dataset_azure_blob.sa_1[0].name
    }
  }

  sink {
    name = "sink1"

    flowlet {
      name = azurerm_data_factory_flowlet_data_flow.fl_df_2.name
      parameters = {
        "Key1" = "value1"
      }
    }

    dataset {
      name = azurerm_data_factory_custom_dataset.dl_1[0].name
    }
  }

  script = <<EOT
source(
  allowSchemaDrift: true, 
  validateSchema: false, 
  limit: 100, 
  ignoreNoFilesFound: false, 
  documentForm: 'documentPerLine') ~> source1 
source1 sink(
  allowSchemaDrift: true, 
  validateSchema: false, 
  skipDuplicateMapInputs: true, 
  skipDuplicateMapOutputs: true) ~> sink1
EOT
}

resource "azurerm_data_factory_flowlet_data_flow" "fl_df_1" {
  name            = "flowlet_1"
  data_factory_id = module.adf[0].adf_id

  source {
    name = "source1"

    linked_service {
      name = azurerm_data_factory_linked_service_azure_blob_storage.adf_sa[0].name
    }
  }

  sink {
    name = "sink1"

    linked_service {
      name = azurerm_data_factory_linked_service_data_lake_storage_gen2.adf_dl[0].name
    }
  }

  script = <<EOT
source(
  allowSchemaDrift: true, 
  validateSchema: false, 
  limit: 100, 
  ignoreNoFilesFound: false, 
  documentForm: 'documentPerLine') ~> source1 
source1 sink(
  allowSchemaDrift: true, 
  validateSchema: false, 
  skipDuplicateMapInputs: true, 
  skipDuplicateMapOutputs: true) ~> sink1
EOT
}

resource "azurerm_data_factory_flowlet_data_flow" "fl_df_2" {
  name            = "flowlet_2"
  data_factory_id = module.adf[0].adf_id

  source {
    name = "source1"

    linked_service {
      name = azurerm_data_factory_linked_service_azure_blob_storage.adf_sa[0].name
    }
  }

  sink {
    name = "sink1"

    linked_service {
      name = azurerm_data_factory_linked_service_data_lake_storage_gen2.adf_dl[0].name
    }
  }

  script = <<EOT
source(
  allowSchemaDrift: true, 
  validateSchema: false, 
  limit: 100, 
  ignoreNoFilesFound: false, 
  documentForm: 'documentPerLine') ~> source1 
source1 sink(
  allowSchemaDrift: true, 
  validateSchema: false, 
  skipDuplicateMapInputs: true, 
  skipDuplicateMapOutputs: true) ~> sink1
EOT
}
