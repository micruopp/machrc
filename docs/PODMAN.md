Podman integration notes

macOS
- Install via Homebrew, `brew install podman`
- Config file stored at `~/.config/containers/containers.conf`
- For silicon, add the following to `containers.conf`:
  ```
  [machine]
  rosetta=false
  ```
  - https://github.com/containers/podman/issues/22918
  - https://github.com/containers/podman/releases/tag/v5.1.0#:~:text=VMs%20created%20by%20podman%20machine%20on%20macOS%20with%20Apple%20silicon%20can%20now%20use%20Rosetta%202%20(a.k.a%20Rosetta)%20for%20high%2Dspeed%20emulation%20of%20x86%20code.%20This%20is%20enabled%20by%20default.%20If%20you%20wish%20to%20change%20this%20option%2C%20you%20can%20do%20so%20in%20containers.conf.
