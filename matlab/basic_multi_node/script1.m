parpool('multinode12') %you must replace the name here with the name of the profile you've made

result=zeros(48, 1);

parfor i=1:48
	pause(60); % just for testing here, so the job takes long enough to run that you can see it
	result(i)=i;
end;

disp(result)
