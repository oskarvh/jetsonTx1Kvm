# jetsonTx1Kvm
This is an exploration trying to get KVM and GPU passthrough to work on the Jetson TX1


It is recommended to do this from an SSD or some form of expanded memory, as it takes up quite a lot of space. See https://www.jetsonhacks.com/2017/01/28/install-samsung-ssd-on-nvidia-jetson-tx1/ for more info. 

However, for the 4.9 kernel, it is needed to configure the extconfig file on the eMMC, due to the device reading the boot config from the internal eMMC, not the SSD unless configured otherwise. 

Important links:
* https://github.com/BaoqianWang/VirtualizationOnJetsonTX2/blob/master/KVM%20on%20Jetson%20TX2.pdf
* https://forums.developer.nvidia.com/t/full-kvm-support-working-on-the-jetson-nano-kernel-virtual-machine-plus-virtio-gpu-passthrough/111703
* https://forums.developer.nvidia.com/t/kvm-problems/112196

