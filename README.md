<img src="https://hddcoin.org/wp-content/uploads/2021/11/HDDcoin_logo_grey_300_smooth-1.png" height="100">

# HDDcoin Docker Container
https://hddcoin.org/

## Configuration
Required configuration:
* Publish network port via `-p 28444:28444`
* Bind mounting a host plot dir in the container to `/plots` (e.g. `-v /path/to/hdd/storage/:/plots`)
* Bind mounting a host config dir in the container to `/root/.hddcoin` (e.g. `-v /path/to/storage/:/root/.hddcoin`)
* Bind mounting a host config dir in the container to `/root/.hddcoin_keys` (e.g. `-v /path/to/storage/:/root/.hddcoin_keys`)
* Set initial `hddcoin keys add` method:
  * Manual input from docker shell via `-e KEYS=type` (recommended)
  * Copy from existing farmer via `-e KEYS=copy` and `-e CA=/path/to/mainnet/config/ssl/ca/` 
  * Add key from mnemonic text file via `-e KEYS=/path/to/mnemonic.txt`
  * Generate new keys (default)

Optional configuration:
* Pass multiple plot directories via PATH-style colon-separated directories (.e.g. `-e plots_dir=/plots/01:/plots/02:/plots/03`)
* Set desired time zone via environment (e.g. `-e TZ=Europe/Berlin`)

On first start with recommended `-e KEYS=type`:
* Open docker shell `docker exec -it <containerid> sh`
* Enter `hddcoin keys add`
* Paste space-separated mnemonic words
* Restart docker cotainer
* Enter `hddcoin wallet show`
* Press `S` to skip restore from backup

## Operation
* Open docker shell `docker exec -it <containerid> sh`
* Check synchronization `hddcoin show -s -c`
* Check farming `hddcoin farm summary`
* Check balance `hddcoin wallet show` 
