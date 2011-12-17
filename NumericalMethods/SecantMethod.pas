Program secant_method;

type
	vector = array[0..256] of real;

var
  //coefficients of polynomial
	coefficients: vector;
	//degree of polynomial
	degree: integer;
	//precision of a solution
	epsilon: real;
	//solution boundries
	x1, x2, x3: real;
	//counter
	i: integer;
	
{procedure write_pl;
begin
	write(coefficients[1],'X^',degree);
	for i:=2 to degree-1 do
		if coefficients[i]<>0 then
			write(' + ',coefficients[1],'X^',degree-i+1);
	if coefficients[degree]<>0 then
			write(' + ',coefficients[degree],'X');
	if coefficients[degree+1]<>0 then
			write(' + ',coefficients[degree+1]);
end;}

procedure write_pl;
begin
	write(coefficients[degree]:0:2,'*X^',degree);
	for i:=degree-1 downto 0 do
		write(' + ',coefficients[i]:0:2,'*X^',i);
end;

function pow (number: real; power: integer): real;
var	result: real; i:integer;
begin
	result := 1;
 	for i:= 1 to power do
		result := result*number;
	pow := result;
end;

function f(x: real): real;
var result: real; i:integer;
begin
	result := 0;
	for i:=0 to degree do begin
		result := result + coefficients[i] * pow(x, i);
	end;
	f := result;
end;

function improve(x1, x2: real): real;
begin
	improve := x2 - f(x2)*(x2-x1)/(f(x2)-f(x1));
end;

function secant_solve(x1s, x2s: real): real;
	var x1, x2, x3: real; k: integer;
begin
	x1 := x1s;
	x2 := x2s;
	k := 0;
	while (abs(x2-x1)>epsilon) and (k<100) do begin
		k := k+1;
		x3 := improve(x1,x2);
		writeln('x(',k+2,')=',x3:0:5);
		x1:=x2;
		x2:=x3;
	end;
	secant_solve := (x2+x1)/2;
end;

Begin
	write('Please enter the degree of polynomial: ');
	readln(degree);
	write('Please enter the aproximate sollution: ');
	write('X^',degree,': ');
	readln(coefficients[degree]);
	for i:=degree-1 downto 0 do begin
		write('X^',i,': ');
		readln(coefficients[i]);
	end;
	writeln;
	write('Your polynomial is: ');
	write_pl;
	write('Please enter the precision: ');
	readln(epsilon);
	writeln('Please enter the sollution boundries: ');
	write('x1: ');
	readln(x1);
	write('x2: ');
	readln(x2);
	writeln;
	x3:=secant_solve(x1, x2);
	writeln('Result: ',x3:0:5);
end.