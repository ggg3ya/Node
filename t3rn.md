# t3rn node executor
by running the executor node, we will generate $BRN

What is $BRN? [Read here](https://www.t3rn.io/blog/announcing-the-t3rn-airdrop-program---brn)

### Download Executor Binary
- Download the executable (`tar.gz`) Executor binary file according to your OS from here: https://github.com/t3rn/executor-release/releases/
```
mkdir t3rn
cd t3rn
```
- Download latest release
```
curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | \
grep -Po '"tag_name": "\K.*?(?=")' | \
xargs -I {} wget https://github.com/t3rn/executor-release/releases/download/{}/executor-linux-{}.tar.gz
```
- Extract the archive
```
tar -xzf executor-linux-*.tar.gz
```
- Navigate to the executor binary location
```
cd executor/executor/bin
```

### Configure Settings and Environment Required Variables
To set the environment variables, copy and paste each command into your terminal. These commands will configure the necessary settings for your Executor to run properly. Make sure you adjust the variable values to your own.
- Set your preferred Node Environment:
```
export NODE_ENV=testnet
```
- Set your log settings:
```
export LOG_LEVEL=debug
export LOG_PRETTY=false
```
- Process bids, orders and claims:
```
export EXECUTOR_PROCESS_BIDS_ENABLED=true
export EXECUTOR_PROCESS_ORDERS_ENABLED=true
export EXECUTOR_PROCESS_CLAIMS_ENABLED=true
```
- Specify limit on gas usage

This will stop your Executor from running if gas rises above this level. The value is in gwei. The default is 1000 gwei.
```
export EXECUTOR_MAX_L3_GAS_PRICE=5000
```

### PRIVATE KEYS
- Set the PRIVATE_KEY_LOCAL variable of your Executor, which is the private key of the wallet you will use:
```
export PRIVATE_KEY_LOCAL=<YOUR_PRIVATE_KEYS>
```
Replace `<YOUR_PRIVATE_KEYS>` with yours


### NETWORKS & RPC
- Add your preferred networks to operate on. Example:
```
export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'
```
#### Configure RPC URL's

- L1RN : 
```
export RPC_ENDPOINTS_L1RN='https://brn.rpc.caldera.xyz/'
```
- BASE SEPOLIA :
```
export RPC_ENDPOINTS_BSSP='https://base-sepolia-rpc.publicnode.com/'
```
- OP SEPOLIA :
```
export RPC_ENDPOINTS_OPSP='https://sepolia.optimism.io/'
```
- ARBITRUM SEPOLIA :
```
export RPC_ENDPOINTS_ARBT='https://arbitrum-sepolia-rpc.publicnode.com/'
```

### Running in Background
```
# Install screen (Ubuntu)
sudo apt-get install screen

# Create and start a new screen session
screen -S t3rn-executor
```

### Start the executor in the screen session
```
./executor
```

