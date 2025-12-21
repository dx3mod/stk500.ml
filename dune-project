(lang dune 3.6)

(name stk500)

(generate_opam_files true)

(source
 (github dx3mod/stk500.ml))

(authors "Mikhail Lopatin <dx3mod@bk.ru>")

(maintainers "Mikhail Lopatin <dx3mod@bk.ru>")

(license MIT)

(package
 (name stk500)
 (synopsis "Stk500 programmer")
 ;  (description "A longer description")
 (depends ocaml)
 (tags
  (embedded avr programmer)))
