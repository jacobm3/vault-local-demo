auto_auth {

  method "approle" {
    config = {
      role_id_file_path = "./role-id"
      secret_id_file_path = "./secret-id"
      remove_secret_id_file_after_reading = false
    }
  }

  sink "file" {
    config = {
      path = "./token-sink"
    }
  }
}

telemetry {
  dogstatsd_addr = "127.0.0.1:8125"
  enable_hostname_label = true
  prometheus_retention_time = "0h"
  usage_gauge_period = "1m"
  usage_gauge_period = "5m"
  disable_hostname = false
  maximum_gauge_cardinality = 100
}
