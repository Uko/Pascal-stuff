Program trapezoidal_rule;

type
	vector = array[0..256] of real;

var
	//coefficients of polynomial
	coefficients: vector;
	//degree of polynomial
	degree: integer;
	//amount of parts
	n: integer;
	//step of the part
	h: real;
	//result of calculation
	result: real;
	//solution boundries
	x1, x2: real;
	//counter
	i: integer;

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
	write('Please enter the amount of division parts: ');
	readln(n);
	writeln('Please enter the integral bounds: ');
	write('x1: ');
	readln(x1);
	write('x2: ');
	readln(x2);
	writeln;
	h := (x2 - x1) / n;
	result := f(x1)+f(x2);
	for i:= 1 to n-1 do
		result := result + 2*f(x1+i*h);
	result := result*h/2;
	write('Result: ',result:0:5);
end.