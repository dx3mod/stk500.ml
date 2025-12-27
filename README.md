# stk500.ml 

Stk500(v1) protocol implementation written in OCaml for program devboards (i.e., starter kits, Arduino) using serial ports. Can be used as a library or standalone.

### Quick start

Installation latest development version via the OPAM package manager. 
```console
$ opam pin stk500.dev https://github.com/dx3mod/stk500.ml.git
```

#### As executable

See help page.
```console
$ stk500 --help
```

Upload the binary firmware to connected board by serial port.
```
$ stk500 upload -p /dev/ttyUSB0 ./firmware.bin
```

#### As library

See documentation page.
```console
$ dune build @doc
$ open _build/default/_doc/_html/index.html
```