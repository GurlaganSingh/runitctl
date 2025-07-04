# rntctl

`rntctl` is a minimal Runit service manager written in pure POSIX shell.

It brings familiar `start`, `enable`, `disable`, and `status` functionality to Void Linux users, similar to `systemctl` or `rc-service` — but without any dependencies beyond standard Runit and shell tools.

---

## ✨ Features

- Start a service **once**, without enabling it at boot
- Enable/disable services for boot
- Check status (enabled/running)
- Safe, fast, and works on **Void Linux by default**
- Pure POSIX shell (no Bash, no Python)

---

## 📦 Installation

Clone the repo and copy `rntctl` somewhere in your `$PATH`:

```sh
git clone https://github.com/YOURUSERNAME/rntctl.git
cd rntctl
chmod +x rntctl
sudo cp rntctl /usr/local/bin/
```
## 💼 usage
```sh
rntctl start <service>     # Run service once (no boot enable)
rntctl enable <service>    # Enable service (symlink to /var/service)
rntctl disable <service>   # Disable service (remove symlink)
rntctl status <service>    # Show if enabled + running status
```
### some examples

```sh
rntctl start emptty
rntctl enable sshd
rntctl disable cups
rntctl status dhcpcd
```
---

📍 Notes

Only tested on Void Linux and Artix linux.

Assumes service definitions in /etc/sv and runsvdir in /var/service or /run/runit/service.

Does not handle custom runsvdir paths — if you want that, fork and enhance!



---

🧑‍💻 License

This project is licensed under the MIT License — see LICENSE for details.
