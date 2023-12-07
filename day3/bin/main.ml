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

let lines = read_lines "input2.txt"
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
    List.iter (
        fun p -> Printf.printf "%d (%d, %d) (%d, %d)\n"
        p.number
        p.start.x p.start.y
        p.endd.x p.endd.y
    ) parts
;;

let explode_string s = List.init (String.length s) (String.get s)
;;

type matrix = {
    value : char list list;
    cols : int;
    rows: int;
}
;;

let get_matrix lines = {
        value = lines |> List.map explode_string;
        cols = String.length (List.nth lines 0);
        rows = List.length lines;
    }
;;

let get_cell matrix point : char option =
    if point.x - 1 < 0 then None else
    if point.x + 1 > matrix.cols then None else
    if point.y - 1 < 0 then None else
    if point.y + 1 > matrix.rows then None
    else Some (List.nth (List.nth matrix.value point.y) point.x)
;;

let get_adj_list matrix point : char list =
    let dirs : point list = [
        { x = -1; y = -1 }; { x = 0; y = -1 }; { x = 1; y = -1 };
        { x = -1; y =  0 };                    { x = 1; y =  0 };
        { x = -1; y =  1 }; { x = 0; y =  1 }; { x = 1; y =  1 }] in
    let move_point p p' = { x = p.x + p'.x; y = p.y + p'.y } in
    dirs
    |> List.map (fun d -> get_cell matrix (move_point point d))
    |> List.map (fun o -> match o with
    | None -> '.'
    | Some(c) -> c)
;;

let explode_part part : point list =
    let rec acc (lst : point list) x : point list =
        match x with
        | _ when x < part.endd.x -> acc lst (x + 1)
        | _ -> lst in
        acc (part.start :: part.endd :: []) part.start.x
;;

let adjacent_to_symbol matrix part : int =
    let points = explode_part part in
    let adj_list = List.flatten (List.map (fun p -> get_adj_list matrix p) points) in
    let adjacent = List.find_opt (fun c -> match c with
        | '0'..'9' -> false
        | '.' -> false
        | _ -> true) adj_list in
    if Option.is_some adjacent then part.number else 0
;;

let sum : int = List.fold_left (fun s p -> s + (adjacent_to_symbol (get_matrix lines) p)) 0 parts
;;

(*
    Solution works, but it probably has a poor performance,
    as it is performing way too many unnecessary opartions.
*)
print_int sum
;;
