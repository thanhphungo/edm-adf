locals {
  diag_info = {
    name               = "${azurerm_data_factory.this.name}-diag"
    target_resource_id = azurerm_data_factory.this.id

    enabled_log = {
      log1 = {
        category                 = "ActivityRuns"
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
      log2 = {
        category                 = "PipelineRuns"
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
      log3 = {
        category                 = "TriggerRuns"
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
      log4 = {
        category                 = "SandboxPipelineRuns"
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
      log5 = {
        category                 = "SandboxActivityRuns"
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
      log6 = {
        category                 = "SSISPackageEventMessages"
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
      log7 = {
        category                 = "SSISPackageExecutableStatistics"
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
      log8 = {
        category                 = "SSISPackageEventMessageContext"
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
      log9 = {
        category                 = "SSISPackageExecutionComponentPhases"
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
      log10 = {
        category                 = "SSISPackageExecutionDataStatistics"
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
      log11 = {
        category                 = "SSISIntegrationRuntimeLogs"
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
    }

    metric = {
      metric1 = {
        category                 = "AllMetrics"
        enabled                  = true
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  count                      = var.adf_info.diagnostics_enabled ? 1 : 0
  name                       = local.diag_info.name
  target_resource_id         = local.diag_info.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = local.diag_info.enabled_log
    content {
      category = enabled_log.value.category
      retention_policy {
        days    = enabled_log.value.retention_policy_days
        enabled = enabled_log.value.retention_policy_enabled
      }
    }
  }

  dynamic "metric" {
    for_each = local.diag_info.metric
    content {
      category = metric.value.category
      enabled  = metric.value.enabled
      retention_policy {
        enabled = metric.value.retention_policy_enabled
      }
    }
  }

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type,
      metric
    ]
  }
}
