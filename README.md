# Liquorix

Liquorix kernel build for Archlinux.

# Version

- 5.14.6-lqx4

# Build

    git clone https://github.com/kevall474/Liquorix.git
    cd Liquorix
    env _cpu_sched=(1,2,3 or 4) _compiler=(1 or 2) makepkg -s

# Build variables

### _cpu_sched

- Will add a CPU Scheduler :

        1 : CacULE by Hamad Al Marri
        2 : CacULE-RDB by Hamad Al Marri
        3 : PDS by Alfred Chen
        4 : BMQ by Alfred Chen

Leave this variable empty if you don't want to add a CPU Scheduler.

### _compiler

- Will set compiler to build the kernel :

        1 : GCC
        2 : CLANG+LLVM

If not set it will build with GCC by default.

# CPU Scheduler

## To come ..

# Update GRUB

    sudo grub-mkconfig -o /boot/grub/grub.cfg

# Contact info

kevall474@tuta.io if you have any problems or bugs report.

# Info

You can refer to this Archlinux page that have lots of useful information to build the kernel and debugging if you have some issues https://wiki.archlinux.org/index.php/Kernel/Traditional_compilation
