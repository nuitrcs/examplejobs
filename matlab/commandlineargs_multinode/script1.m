parpool('multinode12') %you must replace the name here with the name of the profile you've made

%numiter is a variable with the value set in the submission script

result=zeros(numiter, 1);

parfor i=1:numiter
	pause(60); % just for testing here, so the job takes long enough to run that you can see it
	result(i)=i;
end;

disp(result)
