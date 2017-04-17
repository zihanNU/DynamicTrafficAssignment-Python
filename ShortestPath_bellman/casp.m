% shortest path problem solved by continuous approximation
% written by Marco Nie, April 2008.
function [u,p] = casp
A = [1 1 0 0 0;-1 0 1 1 0;0 -1 -1 0 1; 0 0 0 -1 -1];
b = [1;1 ;1; -3];
c = [1 2 0.5 2 0.5];
u = inf * ones(4,1);
p = -1*ones(4,1);
n = 4;
m = 5;
u(n) = 0;
for i = 1:n
    for j = 1:m
        ind = find(A(:,j)~=0);
        ox = ind(1);
        ix = ind(2);
        if u(ox) > u(ix) + c(j);
            u(ox) = u(ix) + c(j);
            p(ox) = j;
        end
    end
    u
    p
    pause
end


