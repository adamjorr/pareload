# pareload
This script finds and reloads a PulseAudio module.

I wrote this because when unplugging and re-connecting my Blue Yeti,
PulseAudio had trouble reloading the correct profiles for it.
Reloading the module fixes that issue. To do so:

```bash
pareload.sh Yeti
```

The script uses grep to search device descriptions from `pacmd list-modules`
and saves the arguments used to initially load the module. It then unloads
the module and reloads it with the same arguments.
