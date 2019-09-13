{% set grub_cfg = '/etc/default/grub' %}

set_grub_cmdline_linux:
  file.line:
    - name: {{ grub_cfg }}
    - mode: replace
    - content: 'GRUB_CMDLINE_LINUX="console=tty1 console=ttyS0,115200"'
    - match: 'GRUB_CMDLINE_LINUX='

enable_grub_terminal:
  file.line:
  - name: {{ grub_cfg }}
  - mode: replace
  - content: 'GRUB_TERMINAL="console serial"'
  - match: 'GRUB_TERMINAL='
  - require:
    - set_grub_cmdline_linux

disable_grub_gfx_mode:
  file.line:
  - name: {{ grub_cfg }}
  - mode: replace
  - content: '# GRUB_GFXMODE="auto"'
  - match: 'GRUB_GFXMODE='
  - require:
    - enable_grub_terminal

set_grub_serial_command:
  file.line:
  - name: {{ grub_cfg }}
  - mode: ensure
  - content: 'GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"'
  - match: 'GRUB_SERIAL_COMMAND='
  - after: 'GRUB_TERMINAL='
  - require:
    - disable_grub_gfx_mode

mk_grub_config:
  cmd.run:
  - name: 'grub2-mkconfig -o /boot/grub2/grub.cfg'
  - require:
    - set_grub_serial_command
  - onchanges:
    - disable_grub_gfx_mode
    - enable_grub_terminal
    - set_grub_cmdline_linux
    - set_grub_serial_command

serial-getty@ttyS0.service:
  service.running:
  - enable: True
  - reload: True
  - force: True
  - watch:
    - mk_grub_config
  - require:
    - mk_grub_config
