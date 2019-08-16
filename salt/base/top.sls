base:
  minio_server:
    - match: nodegroup
    - minion.config.minio_server
  minio_client:
    - match: nodegroup
    - minion.config.minio_client
