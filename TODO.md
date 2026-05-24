# TODO

## Issues

- [ ] **[issue]** `~/.machrc` symlinks into iCloud Drive — every shell startup and prompt draw reads from iCloud, causing multi-minute lockups when iCloud is syncing or offline. Re-point symlink to a local clone (e.g. `~/Developer/machrc`) and use `git push/pull` to sync instead.
