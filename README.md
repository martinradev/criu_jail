# criu jail

This is simple script to isolate shared resources when restoring a criu snapshot.

## Example

```
CRIU_JAIL_MOUNT_DIR=$HOME/my_mount_root criu_jail criu restore ...
```

## What it does

It isolates the following resources:

* PIDs
* /tmp
* PTS indices

