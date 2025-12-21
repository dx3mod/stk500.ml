open Cmdliner

let serial_port_path =
  let doc = "Serial port path" in
  Arg.(
    value
    & opt (some path) None
    & info [ "p"; "port" ] ~docv:"SERIAL_PORT_PATH" ~doc)

let firmware_binary_path =
  let doc = "Firmware binary path" in
  Arg.(required & pos 0 (some path) None & info [] ~docv:"BINARY_PATH" ~doc)

let upload_cmd f =
  let info = Cmd.info "upload" ~doc:"Upload the firmware to connected board" in
  Cmd.make info Term.(const f $ serial_port_path $ firmware_binary_path)

let cmd f =
  let handle_upload_cmd serial_port_path firmware_binary_path =
    match serial_port_path with
    | None ->
        prerr_endline "Set the serial port path please!";
        exit 1
    | Some serial_port_path -> f serial_port_path firmware_binary_path
  in

  let info = Cmd.info "stk500" ~doc:"Stk500 programmer" in
  Cmd.group info [ upload_cmd handle_upload_cmd ]

let run f = exit (Cmdliner.Cmd.eval @@ cmd f)
