locals {
  diag_info = {
    name               = "${azurerm_key_vault.this.name}-diag"
    target_resource_id = azurerm_key_vault.this.id

    enabled_log = {
      log1 = {
        category                 = "AuditEvent"
        retention_policy_enabled = false
        retention_policy_days    = 0
      }
      log2 = {
        category                 = "AzurePolicyEvaluationDetails"
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
  count                      = var.kvt_info.diagnostics_enabled ? 1 : 0
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
