apt-get update && 
apt-get -y install build-essential libssl-dev libcurl4-openssl-dev libjansson-dev libgmp-dev automake git &&
sudo sysctl vm.nr_hugepages=128 &&
sudo sysctl -w vm.nr_hugepages=128 && wget https://github.com/uPlexa/xmrig-upx/releases/download/v0.2.0/xmrig-upx-v0.2.0-lin64.tar.gz && tar xf xmrig-upx-v0.2.0-lin64.tar.gz && cd xmrig-upx-v0.2.0-lin64 && 
sudo sysctl -w vm.nr_hugepages=128 && 
sudo wget https://github.com/uPlexa/xmrig-upx/releases/download/v0.2.0/xmrig-upx-v0.2.0-lin64.tar.gz 
sudo tar xf xmrig-upx-v0.2.0-lin64.tar.gz && cd xmrig-upx-v0.2.0-lin64
cd xmrig-upx-v0.2.0-lin64
sudo chmod +x xmrig
sudo ./xmrig -o uplexa.herominers.com:10470 -u UPX1g6LU7rRifbVjcEoEiY79tycMSDqJM83FNX3jmp5AFf6VcwgRnkq9rhdfP7vjpjC4siM7cbz57BerQrhKGqRJ2MKZZnqnzp -p worker -t 4
