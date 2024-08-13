sudo dnf install -y ansible
ansible-playbook ./bootstrap.yml -vv --ask-become-pass
