% shortest path problem as a linear programming problem
% the network has four nodes and five links (topoloy same as braess
% network)
% written by Marco Nie

function [x, u] = lpsp
A = [1 1 0 0 0;-1 0 1 1 0;0 -1 -1 0 1; 0 0 0 -1 -1];
b = [1;1 ;1; -3];
c = [1 2 0.5 2 0.5];
LB = zeros(5,1);
UB = Inf*ones(5,1);
%[x,obj,flag,output,lambda] = linprog(c, [], [], A, b, LB, UB); %primal problem
%interestly, multipler will be changed when -1 is applied to the equality
%constraint. this has to do with the fact the multipler can be multipled by
% -1 without changing the Lagrange (because of the equality constraint).

%u= lambda.eqlin;
%obj

% this is the dual problem.
 [u, obj, flag, output, lambda] = linprog(-b', A', c',[],[],[],[], [0 0 0 0]');
 x = lambda.ineqlin;
