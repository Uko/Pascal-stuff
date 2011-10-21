Program p1;

type matrix = array[1..256,1..256] of real;

var  main_matrix: matrix;
     equesions: integer;
     
Begin
    write('Please enter the amount of equasions (or 0 for default): ');
    read(equesions);
    if equesions = 0 then
    begin
        // Fill matrix with default value
        //3 5  1 8
        //2 1  7 3
        //1 4 -6 5
        equesions := 3;
        main_matrix[1,1] := 3; main_matrix[1,2] := 5; main_matrix[1,3] := 1; main_matrix[1,4] := 8;
        main_matrix[1,1] := 2; main_matrix[1,2] := 1; main_matrix[1,3] := 7; main_matrix[1,4] := 3;
        main_matrix[1,1] := 1; main_matrix[1,2] := 4; main_matrix[1,3] := -6; main_matrix[1,4] := 5;
    end;
end.

{3 5  1 8
 2 1  7 3
 1 4 -6 5}