# removal of bootstrap
if [ -d /opt/procursus ]; then
    killall Sileo > /dev/null 2>&1
    export PATH=$PATH:/opt/procursus/bin
    sudo apt-get remove sileo -y
    sudo rm -rf /opt/procursus
    rm $HOME/.zshrc
    exit 0
fi

# creating tmp folder
if [ -d tmp ]; then
    rm -rf tmp
fi
mkdir tmp

# cloning and making zstd
git clone https://github.com/facebook/zstd.git
mv zstd tmp/zstd
make -j4 -C tmp/zstd

# downloading procursus
curl -O https://apt.procurs.us/bootstraps/big_sur/bootstrap-darwin-amd64.tar.zst
mv bootstrap-darwin-amd64.tar.zst tmp/bootstrap.tar.zst

# uncompressing bootstrap into raw tar
tmp/zstd/zstd -d tmp/bootstrap.tar.zst

# uncompress bootstrap initially
sudo tar -xpf tmp/bootstrap.tar -C /

# exporting path
export PATH=$PATH:/opt/procursus/bin
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install sileo -y

# zshrc
echo "export PATH=$PATH:/opt/procursus/bin" > $HOME/.zshrc

# launching sileo
/opt/procursus/Applications/Sileo.app/Contents/MacOS/Sileo& > /dev/null 2>&1
disown

killall Terminal
