from datetime import datetime
from psutil import disk_usage, sensors_battery
from psutil._common import bytes2human
from socket import gethostname, gethostbyname
from subprocess import check_output
from sys import stdout
from time import sleep

def write(data):
    stdout.write('%s\n' % data)
    stdout.flush()

def refresh():
    disk = bytes2human(disk_usage('/').free)
    ip = gethostbyname(gethostname())
    # try:
    #     ssid = check_output("iwgetid -r", shell=True).strip().decode("utf-8")
    #     ssid = "(%s)" % ssid
    # except Exception:
    #     ssid = "None"
    # battery = int(sensors_battery().percent)
    # status = "Charging" if sensors_battery().power_plugged else "Discharging"
    date = datetime.now().strftime('%h %d %A %H:%M')
    format = "Space: %s | Internet: %s | Date: %s"
    write(format % (disk, ip, date))

while True:
    refresh()
    sleep(1)
