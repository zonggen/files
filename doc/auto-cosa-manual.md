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
# inside /my/fcos/,
# generated from https://github.com/coreos/coreos-assembler#setup
# init, cp modified installer code, fetch, build
./auto-cosa -i --cp-installer -f -b

# start http server
cd builds/30 && python3 -m http.server 8080 && cd -
./auto-cosa --test-installer
```

Related repositories:
- https://github.com/coreos/coreos-assembler
- https://github.com/coreos/coreos-installer
