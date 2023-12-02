let input = "input2.txt"

let read_file filename =
    let ic = open_in_bin filename in
    let doc = really_input_string ic (in_channel_length ic) in
    close_in ic;
    doc

let doc = read_file input

let lines = String.split_on_char '\n' doc

let is_digit char =
    match char with
    | '0' .. '9' -> true
    | _ -> false

let get_digits s =
    let rec exp i l =
        if i < 0 then l else exp (i - 1) (if is_digit s.[i] then (int_of_char s.[i] - int_of_char '0') :: l else l) in
    exp (String.length s - 1) []

let sum1d list =
    let l = List.length list in
    if l = 0 then 0
    else (List.nth list 0) * 10 + (List.nth list (l - 1))

let digits = List.map get_digits lines

let rec sum2d arr2d = match arr2d with
    | [] -> 0
    | x :: xs -> sum1d x + sum2d xs

let () = Printf.printf "%d" (sum2d digits)
