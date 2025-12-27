let bytes_of_array arr =
  let bytes = Bytes.create (Array.length arr) in
  Array.iteri (Bytes.set_uint8 bytes) arr;
  bytes
