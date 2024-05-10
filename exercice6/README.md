# Exercice6

Customer running workloads on the production systems. The production environment is made highly available and scalable so assume that the application is running on N number of Linux VMs. After launching the application on production one of the QA members reported service impacting bug and should be fixed on priority. Development team worked and fixed the bug. The fixed is into a config file named location.properties. As a DevOps Engineer you need to replace existing /etc/location.property file on all the N VMs with this new file provided by developer.


## Launch script

```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 send_location_prop.py
```
