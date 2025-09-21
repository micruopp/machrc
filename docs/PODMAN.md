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

On initial run:
```
Starting machine "podman-machine-default"

This machine is currently configured in rootless mode. If your containers
require root permissions (e.g. ports < 1024), or if you run into compatibility
issues with non-podman clients, you can switch using the following command:

        podman machine set --rootful

API forwarding listening on: /var/folders/32/_dltnlq90dd693kv76ghhgjc0000gn/T/podman/podman-machine-default-api.sock

The system helper service is not installed; the default Docker API socket
address can't be used by podman. If you would like to install it, run the following commands:

        sudo /opt/homebrew/Cellar/podman/5.6.1/bin/podman-mac-helper install
        podman machine stop; podman machine start

You can still connect Docker API clients by setting DOCKER_HOST using the
following command in your terminal session:

        export DOCKER_HOST='unix:///var/folders/32/_dltnlq90dd693kv76ghhgjc0000gn/T/podman/podman-machine-default-api.sock'

Machine "podman-machine-default" started successfully
```
