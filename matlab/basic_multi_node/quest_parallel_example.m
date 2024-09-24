disp('Start Sim')

iter = 100000;
t0 = tic;
parfor idx = 1:iter
    A(idx) = idx;
end
t = toc(t0);

X = sprintf('Simulation took %f seconds',t);
disp(X)

save RESULTS A t
