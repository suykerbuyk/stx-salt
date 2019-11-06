ntp:
  settings:
    # if `True` starts the ntpd service
    ntpd: True
    # seconds to delay for service start to finish
    init_delay: 5
    ntp_conf:
      server:
        - mgmt.lyve.colo.seagate.com
