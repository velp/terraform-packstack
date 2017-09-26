import sys
import os.path as pt
import string

ANSIBLE_DIR = pt.join(pt.dirname(pt.dirname(pt.abspath(__file__))), "ansible")

if len(sys.argv) < 3:
    print("Use: %s <path_to_ssh_key> <bostion_ip>" % sys.argv[0])
    sys.exit(1)

params = {"ssh_key": sys.argv[1], "bostion_ip": sys.argv[2]}

with open("%s/ssh_config.template" % ANSIBLE_DIR) as tempalte:
    config = string.Template(tempalte.read()).substitute(params)
    with open("%s/ssh_config" % ANSIBLE_DIR, "w") as ssh_config:
        ssh_config.write(config)
