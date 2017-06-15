parpool('local', 4);

%numiter is set in the submission script that calls this file

result=zeros(numiter, 1);

parfor i=1:numiter
	result(i)=i;
end;

disp(result)
disp(numiter)