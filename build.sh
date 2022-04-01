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

cd base && makepkg -s && rm -rf pkg/ src/ && cd ${source}

cd pds && makepkg -s && rm -rf pkg/ src/ && cd ${source}

cd bmq && makepkg -s && rm -rf pkg/ src/ && cd ${source}

# clang

#cd base && env _compiler=2 makepkg -s && rm -rf pkg/ src/ && cd ${source}

#cd pds && env _compiler=2 makepkg -s && rm -rf pkg/ src/ && cd ${source}

#cd bmq && env _compiler=2 makepkg -s && rm -rf pkg/ src/ && cd ${source}
