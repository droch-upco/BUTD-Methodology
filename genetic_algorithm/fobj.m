function [ObjF] = fobj(input)
% This function estimates the adjusted R2 for the regressions of
% the objective indicator Y against all available indicators in X

global Y1 X %i

input = input';
nvars = size(input,1);

x = X;
x = [x(:,:,1); x(:,:,2); x(:,:,3)];

y = Y1(:,1,:);
y = [y(:,:,1); y(:,:,2); y(:,:,3)];

x1 = [];   
for j = 1:nvars                                                           
    if input(j,1) == 1                                          % If commodity is selected
        x1 = [x1 x(:,j)];                                           % Add to pool of variables
    end
end

if sum(input) == 0
    
    ObjF = 99999;
    
else
    mdl = fitlm(x1,y);

    b = table2array(mdl.Coefficients(2:end,1));
    Ind = sum(b<=0);

    ObjF = -mdl.Rsquared.Ordinary + 1*Ind;
end

end

