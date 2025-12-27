let reset ser_port =
  Serialport_unix.Modem.set_data_terminal_ready ser_port false;
  Serialport_unix.Modem.set_request_to_send ser_port false;

  Unix.sleepf 0.2;

  Serialport_unix.Modem.set_data_terminal_ready ser_port true;
  Serialport_unix.Modem.set_request_to_send ser_port true;

  Unix.sleepf 0.25

let send_command oc command = Out_channel.output_bytes oc command

exception Unexpected_response of { expected : bytes; got : bytes }
exception Not_response

let send_command_with_expected ~expected (ic, oc) command =
  send_command oc command;

  match In_channel.really_input_string ic (Array.length expected) with
  | None -> raise Not_response
  | Some response ->
      let response = Bytes.unsafe_of_string response
      and expected = Utils.bytes_of_array expected in
      if response <> expected then
        raise (Unexpected_response { expected; got = response })

let with_open ~baud_rate path f =
  let opts = Serialport.Port_options.make ~baud_rate () in
  Serialport_unix.with_open_communication ~opts path f
