(* Not support Intel Hex yet! *)
let load_firmware_binary filename =
  In_channel.(with_open_bin filename input_all)

let expected_ok = Stk500.V1.Message.[| resp_stk_in_sync; resp_stk_ok |]

type upload_state = { address : int; page_size : int }

let upload_firmware_to_board firmware_binary ser_port =
  let firmware_binary_len = String.length firmware_binary in
  let ic, oc = Serialport_unix.to_channels ser_port in

  Printf.printf "Initialize stage. Entering to programming mode. \n";

  (* Initialize stage. Entering to programming mode. *)
  Printf.printf "Reset the board\n";
  Ser_port.reset ser_port;

  Printf.printf "Send [Sync]\n";
  Ser_port.send_command_with_expected (ic, oc) Stk500.V1.Command.sync
    ~expected:expected_ok;

  Printf.printf "Send [set_options]\n";
  Ser_port.send_command_with_expected (ic, oc) Stk500.V1.Command.set_options
    ~expected:expected_ok;

  Printf.printf "Start programming mode\n";
  Ser_port.send_command_with_expected (ic, oc)
    Stk500.V1.Command.enter_programming_mode ~expected:expected_ok;

  (* Upload loop *)
  let rec aux ({ address; page_size; _ } as state) =
    if address <= firmware_binary_len then begin
      Printf.printf "Send [load_address %d]\n" (address lsr 1);

      Ser_port.send_command_with_expected (ic, oc)
        Stk500.V1.Command.(load_address @@ (address lsr 1))
        ~expected:expected_ok;

      let firmware_binary_page =
        String.sub firmware_binary address
          (min (firmware_binary_len - address) page_size)
      in

      if firmware_binary_page <> String.empty then begin
        Printf.printf "Send [load_page %d lengths]\n"
          (String.length firmware_binary_page);

        Ser_port.send_command_with_expected (ic, oc)
          Stk500.V1.Command.(load_page firmware_binary_page)
          ~expected:expected_ok;

        aux
          {
            state with
            address = (address + String.length firmware_binary_page) land 0xFFFF;
          }
      end
    end
  in

  Printf.printf "Start uploading loop\n";
  aux { address = 0; page_size = 128 };
  Printf.printf "Finish upload\n";

  Printf.printf "Exit programming mode\n";
  Ser_port.send_command_with_expected (ic, oc)
    Stk500.V1.Command.exit_programming_mode ~expected:expected_ok;

  Printf.printf "Final\n"

let main serial_port_path firmware_binary_path =
  Out_channel.set_buffered stdout false;

  let firmware_binary = load_firmware_binary firmware_binary_path in
  Printf.printf "Read firmware binary %d length\n"
    (String.length firmware_binary);

  Printf.printf "Open serial port at %s\n" serial_port_path;
  Ser_port.with_open ~baud_rate:115200 serial_port_path
  @@ upload_firmware_to_board firmware_binary

let () = Cli.run main
