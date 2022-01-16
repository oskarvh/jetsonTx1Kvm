# jetsonTx1Kvm
This is an exploration trying to get KVM and GPU passthrough to work on the Jetson TX1

Hardware: Jetson TX1 developer board
Software: L4T 32.5.1, flashed with JetPack 4.5.1.

It is recommended to do this from an SSD or some form of expanded memory, as it takes up quite a lot of space. See https://www.jetsonhacks.com/2017/01/28/install-samsung-ssd-on-nvidia-jetson-tx1/ for more info. 

However, for the 4.9 kernel, it is needed to configure the extconfig file on the eMMC, due to the device reading the boot config from the internal eMMC, not the SSD unless configured otherwise. 

Important links:
* https://github.com/BaoqianWang/VirtualizationOnJetsonTX2/blob/master/KVM%20on%20Jetson%20TX2.pdf
* https://forums.developer.nvidia.com/t/full-kvm-support-working-on-the-jetson-nano-kernel-virtual-machine-plus-virtio-gpu-passthrough/111703
* https://forums.developer.nvidia.com/t/kvm-problems/112196
* https://forums.developer.nvidia.com/t/tx1-building-l4t-kernel-on-device-failed-to-start-nvpmodel-service/192873

The kernel config is uploaded here as well. 


STATUS:

KVM does not work at the moment. It is compiled in the kernel, but the system is not able to start a qemu VM with KVM due to missing IRQ support (KVM with user space irqchip only works when the host kernel supports KVM_CAP_ARM_USER_IRQ). 

Afaik, to fix this, the DTB needs to be patched, but no reference to this can be found. The memory map is different from e.g. TX2, meaning the patches given in e.g. https://github.com/BaoqianWang/VirtualizationOnJetsonTX2/blob/master/KVM%20on%20Jetson%20TX2.pdf cannot be applied. 
