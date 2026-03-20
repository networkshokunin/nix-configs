```txt
> sudo inxi -Fx -c 0

System:
  Host: mgt1 Kernel: 6.12.76 arch: x86_64 bits: 64 compiler: gcc v: 14.3.0
  Console: pty pts/1 Distro: NixOS 25.11 (Xantusia)
Machine:
  Type: Desktop Mobo: AZW model: MINI S v: 10 serial: N/A UEFI: American Megatrends LLC.
    v: ADLNV104 date: 02/06/2023
CPU:
  Info: quad core model: Intel N100 bits: 64 type: MCP arch: Alder Lake rev: 0 cache: L1: 384 KiB
    L2: 2 MiB L3: 6 MiB
  Speed (MHz): avg: 700 min/max: 700/3400 cores: 1: 700 2: 700 3: 700 4: 700 bogomips: 6451
  Flags-basic: avx avx2 ht lm nx pae sse sse2 sse3 sse4_1 sse4_2 ssse3 vmx
Graphics:
  Device-1: Intel Alder Lake-N [UHD Graphics] driver: i915 v: kernel arch: Xe bus-ID: 00:02.0
  Display: unspecified server: N/A driver: gpu: i915 tty: 137x36 resolution: 1920x1200
  API: N/A Message: No API data available in console. Headless machine?
  Info: Tools: No graphics tools found.
Audio:
  Device-1: Intel Alder Lake-N PCH High Definition Audio driver: snd_hda_intel v: kernel
    bus-ID: 00:1f.3
  API: ALSA v: k6.12.76 status: kernel-api
Network:
  Device-1: Intel Alder Lake-N PCH CNVi WiFi driver: iwlwifi v: kernel bus-ID: 00:14.3
  IF: wlo1 state: down mac: 9a:de:c7:45:42:dd
  Device-2: Realtek RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet driver: r8169 v: kernel
    port: 3000 bus-ID: 01:00.0
  IF: enp1s0 state: up speed: 1000 Mbps duplex: full mac: 7c:83:34:bc:0c:67
Bluetooth:
  Device-1: Intel AX201 Bluetooth driver: btusb v: 0.8 type: USB bus-ID: 1-10:3
  Report: rfkill ID: hci0 rfk-id: 0 state: down bt-service: not found rfk-block: hardware: no
    software: no address: see --recommends
Drives:
  Local Storage: total: 715.41 GiB used: 7.55 GiB (1.1%)
  ID-1: /dev/nvme0n1 model: PCIe SSD size: 476.94 GiB temp: 30.9 C
  ID-2: /dev/sda vendor: Transcend model: TS256GESD310C size: 238.47 GiB type: USB
Partition:
  ID-1: / size: 420.86 GiB used: 7.47 GiB (1.8%) fs: btrfs dev: /dev/nvme0n1p3
  ID-2: /boot size: 951.1 MiB used: 89.9 MiB (9.4%) fs: vfat dev: /dev/nvme0n1p1
Swap:
  ID-1: swap-1 type: partition size: 7.45 GiB used: 0 KiB (0.0%) dev: /dev/nvme0n1p2
Sensors:
  Src: /sys System Temperatures: cpu: 42.0 C mobo: N/A
  Fan Speeds (rpm): N/A
Info:
  Memory: total: 16 GiB available: 15.41 GiB used: 677.3 MiB (4.3%) igpu: 60 MiB
  Processes: 154 Uptime: 0h 48m Init: systemd
  Packages: 396 Compilers: gcc: 14.3.0 Shell: Sudo v: 1.9.17p2 inxi: 3.3.39

> lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    0 238.5G  0 disk
├─sda1        8:1    0 238.4G  0 part
└─sda2        8:2    0    32M  0 part
sr0          11:0    1  1024M  0 rom
nvme0n1     259:0    0 476.9G  0 disk
├─nvme0n1p1 259:1    0   953M  0 part /boot
├─nvme0n1p2 259:2    0   7.5G  0 part [SWAP]
├─nvme0n1p3 259:3    0 420.9G  0 part /persistent
│                                     /nix/store
│                                     /nix
│                                     /
└─nvme0n1p4 259:4    0  47.7G  0 part
```