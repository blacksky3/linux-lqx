#!/bin/bash

# build normal package with GCC

# gcc

cd base && makepkg -s && rm -rf pkg/ src/ && cd ..

cd pds && makepkg -s && rm -rf pkg/ src/ && cd ..

cd bmq && makepkg -s && rm -rf pkg/ src/ && cd ..

# clang

#cd base && env _compiler=2 makepkg -s && rm -rf pkg/ src/ && cd ..

#cd pds && env _compiler=2 makepkg -s && rm -rf pkg/ src/ && cd ..

#cd bmq && env _compiler=2 makepkg -s && rm -rf pkg/ src/ && cd ..
