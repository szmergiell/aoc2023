let read_lines name =
    let ic = open_in name in
    let try_read () = try Some (input_line ic) with End_of_file -> None in
    let rec loop acc = match try_read () with
    | Some s -> loop (s :: acc)
    | None -> close_in ic; List.rev acc in
    loop []

type draw = {
    red : int;
    green : int;
    blue : int;
}

type game = {
    number: int;
    draws : draw list;
}

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
    let red = regex_get_number "\\([0-9]+\\) red" draw_str in
    let green = regex_get_number "\\([0-9]+\\) green" draw_str in
    let blue = regex_get_number "\\([0-9]+\\) blue" draw_str in
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

let string_of_draw draw =
    Printf.sprintf "{ red = %d; green = %d, blue = %d; }" draw.red draw.green draw.blue

let string_of_game game =
    let s = Printf.sprintf "Game: %d" game.number in
    game.draws
    |> List.map string_of_draw
    |> List.fold_left (fun acc s -> acc ^ "\n" ^ s) s

let is_possible_game game =
    if List.for_all (fun d -> d.red <= 12 && d.green <= 13 && d.blue <= 14) game.draws
    then game.number
    else 0


let lines = read_lines "input2.txt"

let ( << ) f g x = f (g x)
let ( >> ) f g x = g (f x)

let result =
    let games = List.map parse_game lines in
    (** games |> List.iter (string_of_game >> print_endline); *)
    let scores = List.map is_possible_game games in
    List.fold_left (fun sum score -> sum + score) 0 scores

let () = print_int result

