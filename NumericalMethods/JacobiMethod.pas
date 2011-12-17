Program gaussian_elimination;

type
	matrix = array[1..256,1..256] of real;
	vector = array[1..256] of real;

var
	//our main matrix
	main_matrix: matrix;
	//arrays of solutions (aproximate ones and improved)
	aprox_solution, solution: vector;
	//precision of a solution
	epsilon: real;
	//amount of equesions in our linear system
	equesions: integer;
	//counters
	i, j, k: integer;

//formated output of the matrix  
procedure write_matrix(output_matrix: matrix; size: integer);
begin
	writeln;
	writeln;
	for i:=1 to size do begin
		for j:=1 to size+1 do
			write(main_matrix[i,j]:0:2,' ');
		writeln;
	end;
end;

//formated output of the solution
procedure write_solution(output_vector: vector; size: integer);
begin
	for i:=1 to size do
		write('X',i,'=',solution[i]:0:2,' ');
end;

//checks if precision is reached for each element in array (compares two passed arrays)
function precision_reached(previous_solution, current_solution: vector; size: integer; precision: real): boolean;
begin
	//solution is precise
	precision_reached := true;
	for i:=1 to size do
		//unless one of it's elements isn't
		if abs(current_solution[i] - previous_solution[i]) > precision then
			precision_reached := false;
end;

//an iteration step that improves passed solution using Jacobi method and returns array of improes solution
function improve(working_matrix: matrix; aproximate_solutions: vector; size: integer): vector;
var
	result: vector;
begin
	for i:=1 to size do begin
		result[i] := working_matrix[i,size+1];
		for j:=1 to size do
			if i<>j then
				result[i] := result[i] - working_matrix[i,j] * aproximate_solutions[j];
		result[i] := result[i]/working_matrix[i,i];
	end;
	improve := result;
end;

Begin
	write('Please enter the amount of equasions (or 0 for default): ');
	read(equesions);
	if equesions = 0 then begin
		// Fill matrix with default value: //
		//  |  4  2 -6 | -10 |             //
		//  |  2 10  9 |  49 |             //
		//  | -6  9 26 |  90 |             //
		equesions := 3;
		main_matrix[1,1] :=  4; main_matrix[1,2] :=  2; main_matrix[1,3] := -6; main_matrix[1,4] := -10;
		main_matrix[2,1] :=  2; main_matrix[2,2] := 10; main_matrix[2,3] :=  9; main_matrix[2,4] :=  49;
		main_matrix[3,1] := -6; main_matrix[3,2] :=  9; main_matrix[3,3] := 26; main_matrix[3,4] :=  90;
	end
	else begin
		writeln('Please enter the matrix (',equesions,'x',equesions+1,'):');
		for i:=1 to equesions do
			for j:=1 to equesions+1 do
				read(main_matrix[i,j]);
	end;
	write('Your matrix is:');
	write_matrix(main_matrix, equesions);
	writeln;
	write('Please enter the aproximate sollution: ');
	for i:=1 to equesions do
		read(solution[i]);
	write('Please enter the precision: ');
	read(epsilon);
	writeln;
	write('aprox(',0,'): ');
	write_solution(solution, equesions);
	k := 0;
	//improvement cycle:
	repeat
		k := k+1;
		aprox_solution := solution;
		solution := improve(main_matrix, solution, equesions);
		writeln;
		write('aprox(',k,'): ');
		write_solution(solution, equesions);
		//will end if solufion is precise or amount of iterations is greater than 1000
	until	precision_reached(aprox_solution, solution, equesions, epsilon) or (k>1000);
end.