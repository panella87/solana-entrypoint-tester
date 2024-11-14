# Solana Entrypoint Tester

This tool is designed to help you identify the best entrypoints to configure in your Solana validator by testing multiple entrypoints, measuring connection success, and logging response times. The results can be used to configure optimal `--entrypoint` parameters for `solana-validator` setup.

## Prerequisites
- **Linux OS**
- **Solana Environment**: Ensure that Solana tools (such as `solana-gossip`) are installed and correctly set up in your environment.

## How to Use

### Step 1: Choose a Known Entrypoint
To begin, you need a working entrypoint (either public, free, or paid) that allows you to fetch a list of additional entrypoints. Use the command:
```bash
solana-gossip spy --entrypoint <IP:PORT>
```
Example:
```bash
solana-gossip spy --entrypoint mainnet.rpcpool.com:8001
```

If the entrypoint is valid, it will return a table with additional IPs and Gossip Ports. A sample output may look like this:

```plaintext
IP Address        |Age(ms)| Node identifier                            | Version |Gossip|TPUvote| TPU  |TPUfwd| TVU  |TVU Q |ServeR|ShredVer
------------------+-------+--------------------------------------------+---------+------+-------+------+------+------+------+------+--------
your.ip.addr.h    |  1802 | *****xp5nJKdqFq1KeY*****Mph8A*****nyba6***** | 1.18.18 | 8002 |  none | none | none | none | none | none | 0
other1.ip.addr.h  |    58 | *****JPUu9w5jEFxaW6*****AJ3gh*****KMCxv***** |    -    | 8000 |  8005 | 8003 | 8004 | 8001 | 8002 | 8008 | 50093
other2.ip.addr.h  |    58 | *****uwEyDPKckw3wEF*****gxMw8*****6doxF***** |    -    | 8001 |  8006 | 8004 | 8005 | 8002 | 8003 | 8009 | 50093
```

### Step 2: Generate an `entrypoints.txt` File
From the output, create a plain text file named `entrypoints.txt` with each line formatted as `IP:Gossip_Port` without any header.

**Example of `entrypoints.txt`:**
```plaintext
1.1.1.1:8000
185.28.32.66:8001
```

### Step 3: Run the Entrypoint Testing Script
Execute the `test_entrypoints.sh` script to test each entrypoint listed in `entrypoints.txt`.

```bash
chmod +x test_entrypoints.sh
./test_entrypoints.sh
```

This script:
- Attempts to connect to each entrypoint.
- Logs each entrypoint’s connection status and ping time to `entrypoints.log` in a CSV format.

### Step 4: View and Use Results
The results will be saved in `entrypoints.log` with the following format:
```plaintext
IP;SUCCESS;PING
1.1.1.1:8000;true;100
185.28.32.66:8001;
192.168.0.1:8001;true;150
```

### Step 5: Process Results for Optimal Configuration
- Copy and paste `entrypoints.log` into a spreadsheet application or import it as a CSV file.
- Sort by the **PING** column to identify entrypoints with the lowest latency.
- Use these results to configure your `solana-validator` parameters with the best entrypoints.
ex. --entrypoint entrypoint2.mainnet-beta.solana.com:8001
