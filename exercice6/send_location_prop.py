from paramiko import SSHClient
from scp import SCPClient

HOSTS = []


def send_loc_prop(host):
    ssh = SSHClient()
    ssh.load_system_host_keys()
    ssh.connect(host)
    scp = SCPClient(ssh.get_transport())
    scp.put("location.property", "/etc/location.property")
    scp.close()


def main():
    failed = 0
    success = 0
    for host in HOSTS:
        try:
            send_loc_prop(host)
        except Exception as e:
            failed += 1
            print("send location.property failed for", host)
            print(e)
        else:
            success += 1
        print(
            "location.property send successfully on",
            success,
            "VMs",
            "and failed on",
            failed,
            "VMs",
        )


if __name__ == "__main__":
    main()
