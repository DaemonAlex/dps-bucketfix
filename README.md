# dps-bucketfix

Tiny watchdog that returns players to routing bucket 0 after `wasabi_spawn`
occasionally strands them in bucket 1 (invisible to everyone else, "ghost
town" symptom on join).

## How it works
A server-side sweep checks player routing buckets and moves anyone found in
bucket 1 back to 0, logging the correction:

```
[bucketfix] Schtoop (1) moved from bucket 1 -> 0 (sweep)
```

## Why it exists
wasabi_multichar/wasabi_spawn use routing buckets during character selection.
On some join paths the restore to bucket 0 is missed. Rather than patch
escrowed code, this resource guarantees the invariant from outside.

Standalone; no configuration, no dependencies beyond the base server.
