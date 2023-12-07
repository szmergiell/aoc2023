let read_lines name =
    let ic = open_in name in
    let try_read () = try Some (input_line ic) with End_of_file -> None in
    let rec loop acc = match try_read () with
    | Some s -> loop (s :: acc)
    | None -> close_in ic; List.rev acc in
    loop []
;;

type point = {
    x : int;
    y : int;
}
;;

type part = {
    number : int;
    start : point;
    endd : point;
}
;;

let lines = read_lines "input1.txt"
;;

let explode_string s = List.init (String.length s) (String.get s)
;;

let rows = List.length lines
;;

let cols = String.length (List.nth lines 0)
;;

let matrix = lines
    |> List.map explode_string
;;

let get_part string col_num pos =
    try
        let _ = Str.search_forward (Str.regexp "[0-9]+") string pos in
        let number = Str.matched_string string in
        let x1 = Str.match_beginning () in
        let x2 = Str.match_end () - 1 in
        Some ({
            number = int_of_string number;
            start = { x = x1; y = col_num};
            endd = { x = x2; y = col_num}
        })
    with
    Not_found -> None
;;

let parse_line (line : string) (col_num : int) : part list =
    let rec acc (lst : part list) pos =
    let part = get_part line col_num pos in
    match part with
    | None -> lst
    | Some(part) -> acc (part :: lst) (part.endd.x + 1) in
    acc [] 0
;;

let parts : part list =
    List.flatten (List.mapi (fun i l -> parse_line l i) (lines))
;;

let () = 
    List.iter (fun p -> Printf.printf "%d (%d, %d) (%d, %d)\n" p.number p.start.x p.start.y p.endd.x p.endd.y) parts
