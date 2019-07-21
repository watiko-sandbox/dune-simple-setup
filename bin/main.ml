open Mylib

let () = 
  let result = Math.add 2 3 in
  print_endline (string_of_int result);
  let result = Mylib.Math.sub 3 1 in (* for test *)
  print_endline (string_of_int result);
  let result = Math.mul 3 3 in
  print_endline (string_of_int result);
