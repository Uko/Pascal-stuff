Program gaus;

type
	matrix = array[1..256,1..256] of real;
	vector = array[1..256] of real;

var
	main_matrix: matrix;
	solution: vector;
	equesions: integer;
	i,j: integer;
	main_determinant: real;

   
procedure write_matrix(output_matrix: matrix; n: integer);
begin
	writeln;
	writeln;
	for i:=1 to n do begin
		for j:=1 to n+1 do
			write(main_matrix[i,j]:0:2,' ');
		writeln;
	end;
end;

procedure to_triangle(var transformer_matrix: matrix; chunk_start, chunk_end: integer);
var
	swap_row: integer;
	swap_buffer: real;
begin
	if chunk_start < chunk_end then begin
		swap_row := chunk_start;
		for i := chunk_start+1 to chunk_end do
			if abs(transformer_matrix[i,chunk_start]) > abs(transformer_matrix[swap_row,chunk_start]) then
				swap_row := i;
		if swap_row <> chunk_start then
			for i := chunk_start to chunk_end+1 do begin
				swap_buffer := transformer_matrix[chunk_start,i];
				transformer_matrix[chunk_start,i] := transformer_matrix[swap_row,i];
				transformer_matrix[swap_row,i] := swap_buffer;
			end;
		for i := chunk_start+1 to chunk_end do
			if transformer_matrix[i,chunk_start] <> 0 then
				for j := chunk_end+1 downto chunk_start do
					transformer_matrix[i,j] := transformer_matrix[i,j] - transformer_matrix[chunk_start,j] * transformer_matrix[i,chunk_start] / transformer_matrix[chunk_start,chunk_start];
		to_triangle(transformer_matrix, chunk_start+1, chunk_end);
	end;			
end;

procedure to_canonical(var transformer_matrix: matrix; chunk_end: integer);
begin
	for i := 1 to chunk_end do
		for j := chunk_end+1 downto i do
			transformer_matrix[i,j] := transformer_matrix[i,j]/transformer_matrix[i,i];
end;

function determinant(working_matrix: matrix; chunk_end: integer): real;
var
	product: real;
begin
	product := 1;
	for i := 1 to chunk_end do
		product := product*working_matrix[i,i];
	determinant := product;
end;

function solve_canonical(canonical_matrix: matrix; chunk_end: integer): vector;
var
	solution: vector;
begin
	solution[chunk_end] := canonical_matrix[chunk_end,chunk_end+1];
	for i:= chunk_end-1 downto 1 do begin
		solution[i] := canonical_matrix[i,chunk_end+1];
		for j := chunk_end downto i+1 do
			solution[i] := solution[i]-canonical_matrix[i,j]*solution[j];
	end;
	solve_canonical := 	solution;
end;	
 
Begin
	write('Please enter the amount of equasions (or 0 for default): ');
	read(equesions);
	if equesions = 0 then begin
		// Fill matrix with default value: //
		//  | 3  5  1 | 8 |                //
		//  | 2  1  7 | 3 |                //
		//  | 1  4 -6 | 5 |                //
		equesions := 3;
		main_matrix[1,1] :=  0; main_matrix[1,2] :=  1; main_matrix[1,3] := 2; main_matrix[1,4] :=  2;
		main_matrix[2,1] := -2; main_matrix[2,2] := -3; main_matrix[2,3] := 1; main_matrix[2,4] := -5;
		main_matrix[3,1] :=  2; main_matrix[3,2] :=  4; main_matrix[3,3] := 0; main_matrix[3,4] :=  6;
	end
	else begin
		writeln('Please enter the matrix (',equesions,'x',equesions+1,'):');
		for i:=1 to equesions do
			for j:=1 to equesions+1 do
				read(main_matrix[i,j]);
	end;
	write('Your matrix is:');
	write_matrix(main_matrix, equesions);
	to_triangle(main_matrix, 1, equesions);
	main_determinant := determinant(main_matrix, equesions);
	if main_determinant = 0 then
		write('Solution of this system is a set of R')
	else begin
		solution := solve_canonical(main_matrix, equesions);
		writeln;
		for i:=1 to equesions do
			write('X',i,'=',solution[i]:0:2,' ');
	end;
end.