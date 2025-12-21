# stk500.ml 

Minimal Stk500(v1) protocol implementation written in OCaml for program devboards (i.e., Arduino) using serial ports. Can be used as a library or standalone.

### Quick start

Installation latest development version via the OPAM package manager. 
```console
$ opam pin stk500.dev https://github.com/dx3mod/stk500.ml.git
```

See help page.
```console
$ stk500 --help
```

Upload the binary firmware to connected board by serial port.
```
$ stk500 upload -p /dev/ttyUSB0 ./firmware.bin
```