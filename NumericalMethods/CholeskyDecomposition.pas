Program cholesky_decomposition;

type
	matrix = array[1..256,1..256] of real;
	vector = array[1..256] of real;

var
	//our main matrix & vector
	main_matrix: matrix;
	main_vector: vector;
	//decomposed matrix
	decomposed_matrix: matrix;
	//array of solutions
	solution: vector;
	//amount of equesions in our linear system
	equesions: integer;
	//counters
	i,j,k: integer;

//formated output of the matrix & vector
procedure write_matrix(output_matrix: matrix; output_vector:vector; n: integer);
begin
	writeln;
	writeln;
	for i:=1 to n do begin
		for j:=1 to n do
			write(main_matrix[i,j]:0:2,' ');
		write(main_vector[i]:0:2);
		writeln;
	end;
end;

//decomposes by Cholesky–Crout algorithm
//returns symethrical matrix that actually represents a merge of two decomposition matrices.
//You can look at it like L+L*,(L* is L-transposed without diagonal values)
function decompose(main_matrix: matrix; bounds: integer): matrix;
var
	result: matrix;
begin
	for j := 1 to bounds do begin
		result[j,j]:=main_matrix[j,j];
		for k := 1 to j-1 do
			result[j,j]:=result[j,j]-sqr(result[j,k]);
		result[j,j]:=sqrt(result[j,j]);
		for i := j+1 to bounds do begin
			result[i,j] := main_matrix[i,j];
			for k := 1 to j-1 do
				result[i,j]	:= result[i,j] - result[i,k]*result[j,k];
			result[i,j]:=result[i,j]/result[j,j];
			result[j,i]:=result[i,j];
		end;
	end;
	decompose:=result;
end;

//solves forst part, e.i. takes left decomposition matrix and main vactor
function pre_solve(main_matrix: matrix; main_vector:vector; bounds: integer): vector;
var
	solution: vector;
begin
	for i := 1 to bounds do begin
		solution[i] := main_vector[i];
		for j:=1 to i-1 do
			solution[i]:=solution[i]-main_matrix[i,j]*solution[j];
		solution[i] := solution[i]/main_matrix[i,i]
	end;
	pre_solve:= solution;
end;	

//solves second part, e.i. takes right decomposition matrix and the result of previous calculation
function solve(main_matrix: matrix; main_vector:vector; bounds: integer): vector;
var
	solution: vector;
begin
	for i := bounds downto 1 do begin
		solution[i] := main_vector[i];
		for j:=i+1 to bounds do
			solution[i]:=solution[i]-main_matrix[i,j]*solution[j];
		solution[i] := solution[i]/main_matrix[i,i]
	end;
	solve:= solution;
end;

Begin
	write('Please enter the amount of equasions (or 0 for default): ');
	read(equesions);
	if equesions = 0 then begin
		// Fill matrix with default value: //
		//  |  4  2 -6 | -10 |               //
		//  |  2 10  9 |  49 |               //
		//  | -6  9 26 |  90 |               //
		equesions := 3;
		main_matrix[1,1] :=  4; main_matrix[1,2] :=  2; main_matrix[1,3] := -6; main_vector[1] := -10;
		main_matrix[2,1] :=  2; main_matrix[2,2] := 10; main_matrix[2,3] :=  9; main_vector[2] :=  49;
		main_matrix[3,1] := -6; main_matrix[3,2] :=  9; main_matrix[3,3] := 26; main_vector[3] :=  90;
	end
	else begin
		writeln('Please enter the matrix (',equesions,'x',equesions+1,'):');
		for i:=1 to equesions do begin
			for j:=1 to equesions do
				read(main_matrix[i,j]);
			read(main_vector[i]);
		end;
	end;
	write('Your matrix is:');
	write_matrix(main_matrix, main_vector, equesions);
	decomposed_matrix := decompose(main_matrix, equesions);
	solution := solve(decomposed_matrix, pre_solve(decomposed_matrix, main_vector, equesions), equesions);
	writeln;
	for i:=1 to equesions do
		write('X',i,'=',solution[i]:0:2,' ');
end.