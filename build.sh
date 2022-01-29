
#!/bin/bash

# build normal package with GCC

# gcc

#makepkg -s

#rm -rf pkg src

env _cpu_sched=1 makepkg -s

rm -rf pkg src

env _cpu_sched=2 makepkg -s

rm -rf pkg src

# clang

#env _compiler=2 makepkg -s

#rm -rf pkg src

#env _cpu_sched=1 _compiler=2 makepkg -s

#rm -rf pkg src

#env _cpu_sched=2 _compiler=2 makepkg -s

#rm -rf pkg src
