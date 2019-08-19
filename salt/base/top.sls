base:
  minio_server:
    - match: nodegroup
    - minion.config.minio.minio_server_running
  minio_client:
    - match: nodegroup
    - minion.config.minio.minio_client
