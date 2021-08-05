# Linux

![image](https://user-images.githubusercontent.com/68618182/124551236-d8491800-ddff-11eb-9143-857197c7a782.png)

Linux kernel build for Archlinux with a patch set by TK-Glitch, Piotr Górski, Hamad Al Marri, Con Kolivas and Alfred Chen.

# Version

- 5.19.19-lqx4

# Build

    git clone https://github.com/kevall474/Liquorix.git
    cd Liquorix
    env _cpu_sched=(1) _compiler=(1 or 2) makepkg -s

# Build variables

### _cpu_sched

- Will add a CPU Scheduler :

        1 : CacULE by Hamad Al Marri
        2 : CacULE-RDB by Hamad Al Marri
        3 : BMQ by Alfred Chen
        4 : PDS by Alfred Chen

Leave this variable empty if you don't want to add a CPU Scheduler.

### _compiler

- Will set compiler to build the kernel :

        1 : GCC
        2 : CLANG+LLVM

If not set it will build with GCC by default.

# CPU Scheduler

## MuQSS CPU Scheduler

MuQSS - The Multiple Queue Skiplist Scheduler by Con Kolivas.

MuQSS is a per-cpu runqueue variant of the original BFS scheduler with
one 8 level skiplist per runqueue, and fine grained locking for much more
scalability.

The goal of the Multiple Queue Skiplist Scheduler, referred to as MuQSS from
here on (pronounced mux) is to completely do away with the complex designs of
the past for the cpu process scheduler and instead implement one that is very
simple in basic design. The main focus of MuQSS is to achieve excellent desktop
interactivity and responsiveness without heuristics and tuning knobs that are
difficult to understand, impossible to model and predict the effect of, and when
tuned to one workload cause massive detriment to another, while still being
scalable to many CPUs and processes.

MuQSS is best described as per-cpu multiple runqueue, O(log n) insertion, O(1)
lookup, earliest effective virtual deadline first tickless design, loosely based
on EEVDF (earliest eligible virtual deadline first) and my previous Staircase
Deadline scheduler, and evolved from the single runqueue O(n) BFS scheduler.
Each component shall be described in order to understand the significance of,
and reasoning for it.

# Update GRUB

    sudo grub-mkconfig -o /boot/grub/grub.cfg

# Contact info

kevall474@tuta.io if you have any problems or bugs report.

# Info

You can refer to this Archlinux page that have lots of useful information to build the kernel and debugging if you have some issues https://wiki.archlinux.org/index.php/Kernel/Traditional_compilation
