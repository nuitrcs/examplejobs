parpool('local', 4);

result=zeros(2000, 1);

parfor i=1:2000
	result(i)=i;
end;

disp(result)