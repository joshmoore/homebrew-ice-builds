export PATH=$PATH:$HOME/Homebrew/bin/
set -e
set -u
set -x
mcpp=`brew --prefix mcpp`
bdb46=`brew --prefix berkeley-db46`
ice33=`brew --prefix zeroc-ice33`
cd cpp && make MCPP_HOME=$mcpp DB_HOME=$bdb46 OPTIMIZE=yes prefix=$ice33 embedded_runpath_prefix=$ice33 install
