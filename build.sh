# _     _            _        _          _____
#| |__ | | __ _  ___| | _____| | ___   _|___ /
#| '_ \| |/ _` |/ __| |/ / __| |/ / | | | |_ \
#| |_) | | (_| | (__|   <\__ \   <| |_| |___) |
#|_.__/|_|\__,_|\___|_|\_\___/_|\_\\__, |____/
#                                  |___/

#Maintainer: blacksky3 <blacksky3@tuta.io> <https://github.com/blacksky3>

#!/bin/bash

source=$(pwd)

echo "${source}"

# build normal package with GCC

# gcc

cd 5.17/base && makepkg -s && rm -rf pkg/ src/ && cd ${source}

cd 5.17/pds && makepkg -s && rm -rf pkg/ src/ && cd ${source}

cd 5.17/bmq && makepkg -s && rm -rf pkg/ src/ && cd ${source}

# clang

#cd 5.17/base && env _compiler=2 makepkg -s && rm -rf pkg/ src/ && cd ${source}

#cd 5.17/pds && env _compiler=2 makepkg -s && rm -rf pkg/ src/ && cd ${source}

#cd 5.17/bmq && env _compiler=2 makepkg -s && rm -rf pkg/ src/ && cd ${source}
