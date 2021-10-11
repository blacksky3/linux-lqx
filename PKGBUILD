#_                   _ _ _  _ _____ _  _
#| | _______   ____ _| | | || |___  | || |
#| |/ / _ \ \ / / _` | | | || |_ / /| || |_
#|   <  __/\ V / (_| | | |__   _/ / |__   _|
#|_|\_\___| \_/ \__,_|_|_|  |_|/_/     |_|

#Maintainer: kevall474 <kevall474@tuta.io> <https://github.com/kevall474>
#Credits: Jan Alexander Steffens (heftig) <heftig@archlinux.org> ---> For the base PKGBUILD
#Credits: Andreas Radke <andyrtr@archlinux.org> ---> For the base PKGBUILD
#Credits: Joan Figueras <ffigue at gmail dot com> ---> For the base PKFBUILD
#Credits: Linus Torvalds ---> For the linux kernel
#Credits: Steven Barrett <steven@liquorix.net> <https://liquorix.net> ---> For the Liquorix patch
#Credits: Con Kolivas <kernel@kolivas.org> <http://ck.kolivas.org/> ---> For MuQSS patches

################# CPU Scheduler #################

#Set CPU Scheduler
#Set '1' for CacULE CPU Scheduler
#Set '2' for CacULE-RDB CPU Scheduler
#Set '3' for PDS CPU Scheduler
#Set '4' for BMQ CPU Scheduler
#Leave empty for no CPU Scheduler
#Default is empty. It will build with no cpu scheduler. To build with cpu shceduler just use : env _cpu_sched=1 makepkg -s
if [ -z ${_cpu_sched+x} ]; then
  _cpu_sched=
fi

################################# Arch ################################

ARCH=x86

################################# GCC ################################

# Grap GCC version
# Workarround with GCC 12.0.0. Pluggins don't work, so we have to grap GCC version
# and disable CONFIG_HAVE_GCC_PLUGINS/CONFIG_GCC_PLUGINS

GCC_VERSION=$(gcc -dumpversion)

################################# CC/CXX/HOSTCC/HOSTCXX ################################

#Set compiler to build the kernel
#Set '1' to build with GCC
#Set '2' to build with CLANG and LLVM
#Default is empty. It will build with GCC. To build with different compiler just use : env _compiler=(1 or 2) makepkg -s
if [ -z ${_compiler+x} ]; then
  _compiler=
fi

if [[ "$_compiler" = "1" ]]; then
  CC=gcc
  CXX=g++
  HOSTCC=gcc
  HOSTCXX=g++
elif [[ "$_compiler" = "2" ]]; then
  CC=clang
  CXX=clang++
  HOSTCC=clang
  HOSTCXX=clang++
else
  _compiler=1
  CC=gcc
  CXX=g++
  HOSTCC=gcc
  HOSTCXX=g++
fi

###################################################################################

# This section set the pkgbase based on the cpu scheduler, so user can build different package based on the cpu scheduler.
if [[ $_cpu_sched = "1" ]]; then
  pkgbase=lqx-kernel-cacule
elif [[ $_cpu_sched = "2" ]]; then
  pkgbase=lqx-kernel-cacule-rdb
elif [[ $_cpu_sched = "3" ]]; then
  pkgbase=lqx-kernel-pds
elif [[ $_cpu_sched = "4" ]]; then
  pkgbase=lqx-kernel-bmq
else
  pkgbase=lqx-kernel
fi
pkgname=("$pkgbase" "$pkgbase-headers")
for _p in "${pkgname[@]}"; do
  eval "package_$_p() {
    $(declare -f "_package${_p#$pkgbase}")
    _package${_p#$pkgbase}
  }"
done
pkgver=5.14.11_lqx1
major=5.14
pkgrel=1
liquorixrel=13
liquorixpatch=v5.14.11-lqx1
arch=(x86_64)
url="https://www.kernel.org/"
license=(GPL-2.0)
makedepends=("bison" "flex" "valgrind" "git" "cmake" "make" "extra-cmake-modules" "libelf" "elfutils"
             "python" "python-appdirs" "python-mako" "python-evdev" "python-sphinx_rtd_theme" "python-graphviz" "python-sphinx"
             "clang" "lib32-clang" "bc" "gcc" "gcc-libs" "lib32-gcc-libs" "glibc" "lib32-glibc" "pahole" "patch" "gtk3" "llvm" "lib32-llvm"
             "llvm-libs" "lib32-llvm-libs" "lld" "kmod" "libmikmod" "lib32-libmikmod" "xmlto" "xmltoman" "graphviz" "imagemagick" "imagemagick-doc"
             "rsync" "cpio" "inetutils" "gzip" "zstd" "xz")
patchsource=https://raw.githubusercontent.com/kevall474/kernel-patches-v2/main/5.13
source=("https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-$major.tar.xz"
        "https://github.com/damentz/liquorix-package/archive/$major-$liquorixrel.tar.gz")
md5sums=("SKIP"
         "SKIP")

export KBUILD_BUILD_HOST=archlinux
export KBUILD_BUILD_USER=$pkgbase
export KBUILD_BUILD_TIMESTAMP="$(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})"

prepare(){

  cd linux-$major

  # Apply liquorix patch
  msg2 "Apply liquorix patch $liquorixpatch"
  patch -Np1 < "$srcdir/liquorix-package-$major-$liquorixrel/linux-liquorix/debian/patches/zen/$liquorixpatch.patch"

  # Apply any patch
  local src
  for src in "${source[@]}"; do
    src="${src%%::*}"
    src="${src##*/}"
    [[ $src = *.patch ]] || continue
    msg2 "Applying patch $src..."
    patch -Np1 < "../$src"
  done

  plain ""

  # Copy the config file first
  # Copy "$srcdir"/liquorix-package-$major-$liquorixrel/linux-liquorix/debian/config/kernelarch-x86/config-arch-64 to "$srcdir"/linux-$major/.config
  msg2 "Copy "$srcdir"/liquorix-package-$major-$liquorixrel/linux-liquorix/debian/config/kernelarch-x86/config-arch-64 to "$srcdir"/linux-$major/.config"
  cp "$srcdir"/liquorix-package-$major-$liquorixrel/linux-liquorix/debian/config/kernelarch-x86/config-arch-64 "$srcdir"/linux-$major/.config

  sleep 2s

  plain ""

  msg2 "Disable LTO"
  scripts/config --disable CONFIG_LTO
  scripts/config --disable CONFIG_LTO_CLANG
  scripts/config --disable CONFIG_ARCH_SUPPORTS_LTO_CLANG
  scripts/config --disable CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN
  scripts/config --disable CONFIG_HAS_LTO_CLANG
  scripts/config --disable CONFIG_LTO_NONE
  scripts/config --disable CONFIG_LTO_CLANG_FULL
  scripts/config --disable CONFIG_LTO_CLANG_THIN

  sleep 2s

  plain ""

  # Disable CacULE PDS/BMQ. We will re-enable later if _cpu_sched=1,2,3 or 4 is set
  msg2 "Disable CacULE PDS/BMQ. We will re-enable later if _cpu_sched=1,2,3 or 4 is set"
  scripts/config --disable CONFIG_CACULE_SCHED
  scripts/config --disable CONFIG_CACULE_RDB
  scripts/config --disable CONFIG_SCHED_ALT
  scripts/config --disable CONFIG_PDS
  scripts/config --disable CONFIG_BMQ

  sleep 2s

  plain ""

  # fix for GCC 12.0.0 (git version)
  if [[ "$GCC_VERSION" = "12.0.0" ]] && [[ "$_compiler" = "1" ]]; then
    plain ""

    #msg2 "Disable CONFIG_HAVE_GCC_PLUGINS/CONFIG_GCC_PLUGINS (Quick fix for gcc 12.0.0 git version)"
    #scripts/config --disable CONFIG_HAVE_GCC_PLUGINS
    #scripts/config --disable CONFIG_GCC_PLUGINS

    #sleep 2s
    
    msg2 "Disable Fortify"
    scripts/config --disable CONFIG_FORTIFY_SOURCE
    scripts/config --disable CONFIG_ARCH_HAS_FORTIFY_SOURCE
    
    plain ""
  fi

  sleep 2s

  plain ""
  
  msg2 "Set kernel compression mode to ZSTD"
  scripts/config --enable CONFIG_HAVE_KERNEL_GZIP
  scripts/config --enable CONFIG_HAVE_KERNEL_BZIP2
  scripts/config --enable CONFIG_HAVE_KERNEL_LZMA
  scripts/config --enable CONFIG_HAVE_KERNEL_XZ
  scripts/config --enable CONFIG_HAVE_KERNEL_LZO
  scripts/config --enable CONFIG_HAVE_KERNEL_LZ4
  scripts/config --enable CONFIG_HAVE_KERNEL_ZSTD
  scripts/config --enable CONFIG_HAVE_KERNEL_UNCOMPRESSED

  scripts/config --disable CONFIG_KERNEL_GZIP
  scripts/config --disable CONFIG_KERNEL_BZIP2
  scripts/config --disable CONFIG_KERNEL_LZMA
  scripts/config --disable CONFIG_KERNEL_XZ
  scripts/config --disable CONFIG_KERNEL_LZO
  scripts/config --disable CONFIG_KERNEL_LZ4
  scripts/config --enable CONFIG_KERNEL_ZSTD
  scripts/config --disable CONFIG_KERNEL_UNCOMPRESSED

  sleep 2s

  msg2 "Set module signature algorithm"
  scripts/config --enable CONFIG_MODULE_SIG
  scripts/config --undefine MODULE_SIG_FORCE
  scripts/config --disable MODULE_SIG_FORCE
  scripts/config --enable CONFIG_MODULE_SIG_ALL
  scripts/config --disable CONFIG_MODULE_SIG_SHA1
  scripts/config --disable CONFIG_MODULE_SIG_SHA224
  scripts/config --disable CONFIG_MODULE_SIG_SHA256
  scripts/config --disable CONFIG_MODULE_SIG_SHA384
  scripts/config --enable CONFIG_MODULE_SIG_SHA512
  scripts/config  --set-val CONFIG_MODULE_SIG_HASH "sha512"

  sleep 2s

  msg2 "Set module compression to ZSTD"
  scripts/config --disable CONFIG_MODULE_COMPRESS_NONE
  scripts/config --disable CONFIG_MODULE_COMPRESS_GZIP
  scripts/config --disable CONFIG_MODULE_COMPRESS_XZ
  scripts/config --enable CONFIG_MODULE_COMPRESS_ZSTD

  sleep 2s

  msg2 "Enable CONFIG_STACK_VALIDATION"
  scripts/config --enable CONFIG_STACK_VALIDATION

  sleep 2s

  msg2 "Enable IKCONFIG"
  scripts/config --enable CONFIG_IKCONFIG
  scripts/config --enable CONFIG_IKCONFIG_PROC

  sleep 2s

  msg2 "Disable NUMA"
  scripts/config --disable CONFIG_NUMA
  scripts/config --disable CONFIG_AMD_NUMA
  scripts/config --disable CONFIG_X86_64_ACPI_NUMA
  scripts/config --disable CONFIG_NODES_SPAN_OTHER_NODES
  scripts/config --disable CONFIG_NUMA_EMU
  scripts/config --disable CONFIG_NEED_MULTIPLE_NODES
  scripts/config --disable CONFIG_USE_PERCPU_NUMA_NODE_ID
  scripts/config --disable CONFIG_ACPI_NUMA
  scripts/config --disable CONFIG_ARCH_SUPPORTS_NUMA_BALANCING
  scripts/config --disable CONFIG_NODES_SHIFT
  scripts/config --undefine CONFIG_NODES_SHIFT
  scripts/config --disable CONFIG_NEED_MULTIPLE_NODES

  sleep 2s

  msg2 "Disable FUNCTION_TRACER/GRAPH_TRACER"
  scripts/config --disable CONFIG_FUNCTION_TRACER
  scripts/config --disable CONFIG_STACK_TRACER

  sleep 2s

  msg2 "Disable CONFIG_USER_NS_UNPRIVILEGED"
  scripts/config --enable CONFIG_USER_NS_UNPRIVILEGED

  sleep 2s

  msg2 "Set CPU Frequency scaling CONFIG_CPU_FREQ_DEFAULT_GOV/CONFIG_CPU_FREQ_GOV for performance"
  scripts/config --disable CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE
  scripts/config --disable CONFIG_CPU_FREQ_GOV_POWERSAVE
  scripts/config --disable CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE
  scripts/config --disable CONFIG_CPU_FREQ_GOV_USERSPACE
  scripts/config --disable CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
  scripts/config --disable CONFIG_CPU_FREQ_GOV_ONDEMAND
  scripts/config --disable CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
  scripts/config --disable CONFIG_CPU_FREQ_GOV_CONSERVATIVE
  scripts/config --disable CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL
  scripts/config --disable CONFIG_CPU_FREQ_GOV_SCHEDUTIL
  scripts/config --enable CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE
  scripts/config --enable CONFIG_CPU_FREQ_GOV_PERFORMANCE

  sleep 2s

  msg2 "Set CPU DEVFREQ GOV CONFIG_DEVFREQ_GOV for performance"
  scripts/config --disable CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND
  scripts/config --undefine CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND
  scripts/config --disable CONFIG_DEVFREQ_GOV_POWERSAVE
  scripts/config --disable CONFIG_DEVFREQ_GOV_USERSPACE
  scripts/config --disable CONFIG_DEVFREQ_GOV_PASSIVE
  scripts/config --enable CONFIG_DEVFREQ_GOV_PERFORMANCE

  sleep 2s

  msg2 "Set PCIEASPM DRIVER to performance"
  scripts/config --enable CONFIG_PCIEASPM
  scripts/config --enable CONFIG_PCIEASPM_PERFORMANCE

  sleep 2s

  msg2 "Set CONFIG_PCIE_BUS for performance"
  scripts/config --enable CONFIG_PCIE_BUS_PERFORMANCE

  sleep 2s

  msg2 "Enable CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3"
  scripts/config --disable CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE
  scripts/config --disable CONFIG_CC_OPTIMIZE_FOR_SIZE
  scripts/config --enable CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3

  sleep 2s

  if [[ $_cpu_sched = "1" ]] || [[ $_cpu_sched = "2" ]]; then
    msg2 "Set timer frequency to 2000HZ"
    scripts/config --enable CONFIG_HZ_2000
    scripts/config --set-val CONFIG_HZ 2000
  else
    msg2 "Set timer frequency to 1000HZ"
    scripts/config --enable CONFIG_HZ_1000
    scripts/config --set-val CONFIG_HZ 1000
  fi

  sleep 2s

  msg2 "Enable PREEMPT"
  scripts/config --disable CONFIG_PREEMPT_NONE
  scripts/config --disable CONFIG_PREEMPT_VOLUNTARY
  scripts/config --enable CONFIG_PREEMPT
  scripts/config --enable CONFIG_PREEMPT_COUNT
  scripts/config --enable CONFIG_PREEMPTION

  sleep 2s

  msg2 "Enable CONFIG_FORCE_IRQ_THREADING"
  scripts/config --enable CONFIG_FORCE_IRQ_THREADING

  sleep 2s

  msg2 "Set to full tickless"
  scripts/config --disable CONFIG_HZ_PERIODIC
  scripts/config --disable CONFIG_NO_HZ_IDLE
  scripts/config --enable CONFIG_NO_HZ_FULL
  scripts/config --enable CONFIG_NO_HZ
  scripts/config --enable CONFIG_NO_HZ_COMMON
  #scripts/config --enable CONFIG_CONTEXT_TRACKING
  #scripts/config --disable CONFIG_CONTEXT_TRACKING_FORCE

  sleep 2s

  msg2 "Enable ntfs"
  scripts/config --module CONFIG_NTFS_FS
  scripts/config --enable CONFIG_NTFS_RW

  sleep 2s

  msg2 "Enable BBR/BBR2 TCP"
  scripts/config --module CONFIG_TCP_CONG_BBR
  scripts/config --module CONFIG_TCP_CONG_BBR2

  sleep 2s

  msg2 "Enable CONFIG_VHBA"
  scripts/config --module CONFIG_VHBA

  sleep 2s

  msg2 "Disabling Kyber I/O scheduler"
  scripts/config --disable CONFIG_MQ_IOSCHED_KYBER

  sleep 2s

  msg2 "Enable Deadline I/O scheduler"
  scripts/config --enable CONFIG_MQ_IOSCHED_DEADLINE

  sleep 2s

  msg2 "Enable MQ-Deadline-Nodefault I/O scheduler"
  scripts/config --enable CONFIG_MQ_IOSCHED_DEADLINE_NODEFAULT

  sleep 2s

  msg2 "Enable CONFIG_BFQ_CGROUP_DEBUG"
  scripts/config --enable CONFIG_BFQ_CGROUP_DEBUG

  sleep 2s

  msg2 "Enable ZEN_INTERACTIVE"
  scripts/config --enable ZEN_INTERACTIVE

  sleep 2s

  msg2 "Enable Fsync support"
  scripts/config --enable CONFIG_FUTEX
  scripts/config --enable CONFIG_FUTEX_PI

  sleep 2s

  msg2 "Enable Futex2 support"
  scripts/config --enable CONFIG_FUTEX2

  sleep 2s

  msg2 "Enable OpenRGB SMBus access"
  scripts/config --module CONFIG_I2C_NCT677

  sleep 2s

  msg2 "Enable LRU"
  scripts/config --enable CONFIG_LRU_GEN
  scripts/config --enable CONFIG_LRU_GEN_ENABLED
  scripts/config --enable CONFIG_LRU_GEN_STATS

  sleep 2s

  if [[ $_cpu_sched = "1" ]]; then
    msg2 "Enable CacULE CPU scheduler"
    scripts/config --enable CONFIG_CACULE_SCHED
    scripts/config --disable CONFIG_CACULE_RDB
  elif [[ $_cpu_sched = "2" ]]; then
    msg2 "Enable CacULE CPU scheduler"
    scripts/config --enable CONFIG_CACULE_SCHED
    msg2 "Enable CacULE-RDB CPU scheduler"
    scripts/config --enable CONFIG_CACULE_RDB
  elif [[ $_cpu_sched = "3" ]]; then
    msg2 "Enable CONFIG_SCHED_ALT, this feature enable alternative CPU scheduler"
    scripts/config --enable CONFIG_SCHED_ALT
    msg2 "Enable PDS CPU scheduler"
    scripts/config --enable CONFIG_SCHED_PDS
    scripts/config --disable CONFIG_SCHED_BMQ
  elif [[ $_cpu_sched = "4" ]]; then
    msg2 "Enable CONFIG_SCHED_ALT, this feature enable alternative CPU scheduler"
    scripts/config --enable CONFIG_SCHED_ALT
    msg2 "Enable BMQ CPU scheduler"
    scripts/config --disable CONFIG_SCHED_PDS
    scripts/config --enable CONFIG_SCHED_BMQ
  else
    msg2 "Enable CFS"
    scripts/config --enable SCHED_NORMAL
    scripts/config --enable SCHED_BATCH
    scripts/config --enable SCHED_IDLE
    scripts/config --enable CONFIG_CGROUP_SCHED
    scripts/config --enable CONFIG_FAIR_GROUP_SCHED
    scripts/config --enable CONFIG_CFS_BANDWIDTH
    scripts/config --enable CONFIG_SCHED_DEBUG
  fi

  sleep 2s

  msg2 "Set CONFIG_GENERIC_CPU"
  scripts/config --enable CONFIG_GENERIC_CPU

  sleep 2s

  plain ""

  # Setting localversion
  msg2 "Setting localversion..."
  scripts/setlocalversion --save-scmversion
  echo "-${pkgbase}" > localversion

  # Config
  if [[ "$_compiler" = "1" ]]; then
    make ARCH=${ARCH} CC=${CC} CXX=${CXX} HOSTCC=${HOSTCC} HOSTCXX=${HOSTCXX} olddefconfig
  elif [[ "$_compiler" = "2" ]]; then
    make ARCH=${ARCH} CC=${CC} CXX=${CXX} LLVM=1 LLVM_IAS=1 HOSTCC=${HOSTCC} HOSTCXX=${HOSTCXX} olddefconfig
  fi

  make -s kernelrelease > version
  msg2 "Prepared $pkgbase version $(<version)"
}

build(){

  cd linux-$major

  # make -j$(nproc) all
  msg2 "make -j$(nproc) all..."
  if [[ "$_compiler" = "1" ]]; then
    make ARCH=${ARCH} CC=${CC} CXX=${CXX} HOSTCC=${HOSTCC} HOSTCXX=${HOSTCXX} -j$(nproc) all
  elif [[ "$_compiler" = "2" ]]; then
    make ARCH=${ARCH} CC=${CC} CXX=${CXX} LLVM=1 LLVM_IAS=1 HOSTCC=${HOSTCC} HOSTCXX=${HOSTCXX} -j$(nproc) all
  fi
}

_package(){
  pkgdesc="Liquorix kernel and modules"
  depends=("coreutils" "kmod" "initramfs" "mkinitcpio")
  optdepends=("linux-firmware: firmware images needed for some devices"
              "crda: to set the correct wireless channels of your country")
  provides=("VIRTUALBOX-GUEST-MODULES" "WIREGUARD-MODULE")

  cd linux-$major

  local kernver="$(<version)"
  local modulesdir="${pkgdir}"/usr/lib/modules/${kernver}

  msg2 "Installing boot image..."
  # systemd expects to find the kernel here to allow hibernation
  # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
  #install -Dm644 arch/${ARCH}/boot/bzImage "$modulesdir/vmlinuz"
  msg2 "install -Dm644 "$(make -s image_name)" "$modulesdir/vmlinuz""
  install -Dm644 "$(make -s image_name)" "$modulesdir/vmlinuz"

  # Used by mkinitcpio to name the kernel
  msg2 "echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir/pkgbase""
  echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir/pkgbase"

  msg2 "Installing modules..."
  if [[ "$_compiler" = "1" ]]; then
    make ARCH=${ARCH} CC=${CC} CXX=${CXX} HOSTCC=${HOSTCC} HOSTCXX=${HOSTCXX} INSTALL_MOD_PATH="${pkgdir}"/usr INSTALL_MOD_STRIP=1 -j$(nproc) modules_install
  elif [[ "$_compiler" = "2" ]]; then
    make ARCH=${ARCH} CC=${CC} CXX=${CXX} LLVM=1 LLVM_IAS=1 HOSTCC=${HOSTCC} HOSTCXX=${HOSTCXX} INSTALL_MOD_PATH="${pkgdir}"/usr INSTALL_MOD_STRIP=1 -j$(nproc) modules_install
  fi

  # remove build and source links
  msg2 "Remove build dir and source dir..."
  rm -rf "$modulesdir"/{source,build}

  # workaround for missing header with winesync
  #if [ -e "${srcdir}/linux-$pkgver/include/uapi/linux/winesync.h" ]; then
  #  msg2 "Workaround missing winesync header"
  #  install -Dm644 "${srcdir}/linux-$pkgver"/include/uapi/linux/winesync.h "${pkgdir}/usr/include/linux/winesync.h"
  #fi

  # load winesync module at boot
  #if [ -e "${srcdir}/winesync.conf" ]; then
  #  msg2 "Set the winesync module to be loaded at boot through /etc/modules-load.d"
  #  install -Dm644 "${srcdir}"/winesync.conf "${pkgdir}/etc/modules-load.d/winesync.conf"
  #fi

  # install udev rule for winesync
  #if [ -e "${srcdir}/winesync.rules" ]; then
  #  msg2 "Installing udev rule for winesync"
  #  install -Dm644 "${srcdir}"/winesync.rules "${pkgdir}/etc/udev/rules.d/winesync.rules"
  #fi
}

_package-headers(){
  pkgdesc="Headers and scripts for building modules for the $pkgbase package"
  depends=("${pkgbase}" "pahole")

  cd linux-$major

  local builddir="$pkgdir"/usr/lib/modules/"$(<version)"/build

  msg2 "Installing build files..."
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map localversion version vmlinux
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/x86" -m644 arch/x86/Makefile
  cp -t "$builddir" -a scripts

  # add objtool for external module building and enabled VALIDATION_STACK option
  install -Dt "$builddir/tools/objtool" tools/objtool/objtool

  # add xfs and shmem for aufs building
  mkdir -p "$builddir"/{fs/xfs,mm}

  msg2 "Installing headers..."
  cp -t "$builddir" -a include
  cp -t "$builddir/arch/x86" -a arch/x86/include
  install -Dt "$builddir/arch/x86/kernel" -m644 arch/x86/kernel/asm-offsets.s

  install -Dt "$builddir/drivers/md" -m644 drivers/md/*.h
  install -Dt "$builddir/net/mac80211" -m644 net/mac80211/*.h

  # https://bugs.archlinux.org/task/13146
  install -Dt "$builddir/drivers/media/i2c" -m644 drivers/media/i2c/msp3400-driver.h

  # https://bugs.archlinux.org/task/20402
  install -Dt "$builddir/drivers/media/usb/dvb-usb" -m644 drivers/media/usb/dvb-usb/*.h
  install -Dt "$builddir/drivers/media/dvb-frontends" -m644 drivers/media/dvb-frontends/*.h
  install -Dt "$builddir/drivers/media/tuners" -m644 drivers/media/tuners/*.h

  # https://bugs.archlinux.org/task/71392
  install -Dt "$builddir/drivers/iio/common/hid-sensors" -m644 drivers/iio/common/hid-sensors/*.h

  msg2 "Installing KConfig files..."
  find . -name 'Kconfig*' -exec install -Dm644 {} "$builddir/{}" \;

  msg2 "Removing unneeded architectures..."
  local arch
  for arch in "$builddir"/arch/*/; do
    [[ $arch = */x86/ ]] && continue
    msg2 "Removing $(basename "$arch")"
    rm -r "$arch"
  done

  msg2 "Removing documentation..."
  rm -r "$builddir/Documentation"

  msg2 "Removing broken symlinks..."
  find -L "$builddir" -type l -printf 'Removing %P\n' -delete

  msg2 "Removing loose objects..."
  find "$builddir" -type f -name '*.o' -printf 'Removing %P\n' -delete

  msg2 "Stripping build tools..."
  local file
  while read -rd '' file; do
    case "$(file -bi "$file")" in
      application/x-sharedlib\;*)      # Libraries (.so)
        strip -v $STRIP_SHARED "$file" ;;
      application/x-archive\;*)        # Libraries (.a)
        strip -v $STRIP_STATIC "$file" ;;
      application/x-executable\;*)     # Binaries
        strip -v $STRIP_BINARIES "$file" ;;
      application/x-pie-executable\;*) # Relocatable binaries
        strip -v $STRIP_SHARED "$file" ;;
    esac
  done < <(find "$builddir" -type f -perm -u+x ! -name vmlinux -print0)

  msg2 "Stripping vmlinux..."
  strip -v $STRIP_STATIC "$builddir/vmlinux"

  msg2 "Adding symlink..."
  mkdir -p "$pkgdir/usr/src"
  ln -sr "$builddir" "$pkgdir/usr/src/$pkgbase"
}
