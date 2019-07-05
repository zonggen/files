## Automate testing on `fedora-coreos-30`

Directory structure on my machine:
```text
.
├── coreos-assembler
├── coreos-installer
└── fcos
    └── auto-cosa
```

Commandline pipeline:

```bash
# inside /my/fcos/dir,
# generated from https://github.com/coreos/coreos-assembler#setup
./auto-cosa -i --cp-installer -f -b --test-installer
```

Related repositories:
- https://github.com/coreos/coreos-assembler
- https://github.com/coreos/coreos-installer