# Example graph
<img src="example_outputs/charging.png" width="auto" style="max-width:300px;">

# How to use
## setup
```bash
python3 -m venv battery_env
source battery_env/bin/activate
pip install -r requirements.txt
mkdir outputs
```
## use
```bash
source battery_env/bin/activate
python charging.py 'example data/charging.csv'
```

# Current headers
|date                           |timestamp  |voltage |battery|charge  |current |current_avg|cpu0_freq|cpu1_freq|cpu2_freq|cpu3_freq|cpu0_load|cpu1_load|cpu2_load|cpu3_load|
|-------------------------------|-----------|--------|-------|--------|--------|-----------|---------|---------|---------|---------|---------|---------|---------|---------|
|Thu 13 Mar 2025 05:46:08 PM +05| 1741869968| 3710312| 49    | 2105578| -485527| -440536   | 1.50    |1.50     |1.50     |1.50     | 10.7%   |11.1%    |11.1%    |11.2%    |
|Thu 13 Mar 2025 05:46:19 PM +05| 1741869979| 3724218| 48    | 2105578| -449910| -410542   | 1.50    |1.50     |1.50     |1.50     | 10.7%   |11.1%    |11.1%    |11.2%    |

# TODO
- [ ] record if screen is on
- [ ] check top 3 process
- [ ] find true CPU temp?

