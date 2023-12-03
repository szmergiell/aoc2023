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

let is_digit_word str =
    match str with
    | "one" -> 1
    | "two" -> 2
    | "three" -> 3
    | "four" -> 4
    | "five" -> 5
    | "six" -> 6
    | "seven" -> 7
    | "eight" -> 8
    | "nine" -> 9
    | _ -> 0

let get_digits s =
    let rec exp i l =
        match i with
        | _ when (i < 0) -> l
        | _ -> exp (i - 1) (
            match s.[i] with
            | c when (is_digit c) -> (int_of_char s.[i] - int_of_char '0') :: l
            | 'o' | 't' | 'f' | 's' | 'e' | 'n' ->
                    begin
                        let ml = min 5 (String.length s - i) in
                        match ml with
                        | _ when (ml < 3) -> l
                        | _ ->
                                begin
                                    let substr = String.sub s i in
                                    let id l = is_digit_word (substr l) in
                                    match s with
                                    | _ when (ml >= 3 && id 3 <> 0) -> id 3 :: l
                                    | _ when (ml >= 4 && id 4 <> 0) -> id 4 :: l
                                    | _ when (ml >= 5 && id 5 <> 0) -> id 5 :: l
                                    | _ -> l
                                end;
                    end;
            | _ -> l
            ) in
    exp (String.length s - 1) []

let sum1d list =
    match list with
    | [] -> 0
    | _ -> (List.nth list 0) * 10 + (List.nth list ((List.length list) - 1))

let digits = List.map get_digits lines

let _int_list_list_pp = [%show: int list list]

let _string_of_int_list_list = Format.asprintf "@[%a@]" _int_list_list_pp

(** let () = print_endline (_string_of_int_list_list digits) *)

let rec sum2d arr2d = match arr2d with
    | [] -> 0
    | x :: xs -> sum1d x + sum2d xs

let () = Printf.printf "%d" (sum2d digits)
