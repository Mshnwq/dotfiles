# If you can't find `systemd-resolved`, here's how to check if it's **installed**, **running**, and how to **configure or disable** it.
#
# ---
#
# ## 🔍 1. **Check if `systemd-resolved` is running**
#
# Run:
#
# ```bash
# systemctl status systemd-resolved
# ```
#
# * If it's **active (running)**, then it's your system's DNS resolver.
# * If you get an error like `Unit systemd-resolved.service could not be found.`, it's **not installed or not used** on your system.
#
# ---
#
# ## 📍 2. **Check where your system is getting DNS info**
#
# ```bash
# resolvectl status
# ```
#
# If `resolvectl` reports back DNS info, then `systemd-resolved` is in use.
#
# If not, check your `/etc/resolv.conf`:
#
# ```bash
# cat /etc/resolv.conf
# ```
#
# Look for a line like:
#
# ```
# nameserver 127.0.0.53
# ```
#
# If you see that, then `systemd-resolved` is likely managing DNS.
#
# ---
#
# ## ⚙️ 3. **LLMNR config for `systemd-resolved`**
#
# If `systemd-resolved` is installed, the config file is usually:
#
# ```
# /etc/systemd/resolved.conf
# ```
#
# ### Edit it:
#
# ```bash
# sudo nano /etc/systemd/resolved.conf
# ```
#
# ### Find or add this section:
#
# ```ini
# [Resolve]
# LLMNR=no
# ```
#
# Then **restart** the service:
#
# ```bash
# sudo systemctl restart systemd-resolved
# ```
#
# ---
#
# ## ❌ 4. If `systemd-resolved` is **not installed**?
#
# If you're on a system that doesn't use `systemd-resolved` (e.g., some minimalist distros or custom setups), LLMNR might be handled by something else or not at all. You can still block it with the firewall (as we did earlier), which is enough in most cases.
#
# ---
#
# Would you like me to help determine what DNS resolver your system is using instead?
#
