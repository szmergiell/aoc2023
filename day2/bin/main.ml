let input = "input1.txt"

let read_file filename =
    let ic = open_in_bin filename in
    let doc = really_input_string ic (in_channel_length ic) in
    close_in ic;
    doc

let doc = read_file input

let lines = String.split_on_char '\n' doc

let line : string = List.nth lines 0

type draw = {
    red : int;
    green : int;
    blue : int;
}

type game = {
    number: int;
    draws : draw list;
}

let () = print_endline line

let regex_get_number regex line =
    try
        let _ = Str.search_forward (Str.regexp regex) line 0 in
        let number_string = Str.matched_group 1 line in
        Some (int_of_string number_string)
    with
    Not_found -> None

let get_some_or option default =
    match option with
    | Some v -> v
    | None -> default

let parse_game_number line =
    regex_get_number "Game \\([0-9]+\\)" line

let parse_game_draw draw_str =
    let red = regex_get_number "\\([0-9]\\)+ red" draw_str in
    let green = regex_get_number "\\([0-9]\\)+ green" draw_str in
    let blue = regex_get_number "\\([0-9]\\)+ blue" draw_str in
    {
        red = get_some_or red 0;
        green = get_some_or green 0;
        blue = get_some_or blue 0;
    }

let parse_game_draws line : draw list =
    String.split_on_char ';' line
    |> List.map parse_game_draw

let parse_game line = {
        number = get_some_or (parse_game_number line) 0;
        draws = parse_game_draws line;
    }

let game = parse_game line

let string_of_draw draw =
    Printf.sprintf "{ red = %d; green = %d, blue = %d; }" draw.red draw.green draw.blue

let string_of_draws draws =
    List.map (fun d -> Printf.sprintf "Draw number: %d %s" 0 (string_of_draw d)) draws

let string_of_game game =
    Printf.sprintf "Game: %d" game.number

let () = (string_of_draws game.draws)
    |> List.iter print_endline

