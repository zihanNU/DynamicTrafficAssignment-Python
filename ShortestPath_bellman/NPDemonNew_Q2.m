%provide a demo for 1: how to use fmincon
%and                2: how to use projection 

function xstar = npdemonnew(x0)

%minmize funciton myquad, which is a quadratic function defined below,
%using fmincon
[xstar,FVAL,EXITFLAG,OUTPUT,LAMBDA] = fmincon(@(x)myquad(x) ,[0;0], [],[],[1 5],3,[0 0],[]); 
x1 = [-2: 0.05:2];
x2 = [-2:0.05:2];
n = length(x1);
z = zeros(n,n);
y = zeros(n,1);
for i = 1:n
    y(i) = 0.2*(3-x1(i));
    for j = 1:n
        z(i,j) = feval(@myquad, [x1(i) x2(j)]);
    end
end
%create countourf 
h = contourf(x1, x2, z,20);
%add the line to show the contraint
line(x1, y,'color','r');
line(xstar(1), xstar(2), 'color','r', 'marker','o','markersize', 8);
colorbar;
%now call the projection algorithm to solve the same minimization problem. 
path = myproj(x0);
path
line(path(:,1), path(:,2), 'color','y', 'marker','+', 'markersize',3);

%the implementation of a projection algorithm
function path = myproj(x0)
H = [12 0;0 10];
b = [0 0];
A = [1, 5];
c = 3;
x = x0;
x1 = x+1;
i = 1;
r = 0.1;
path(i,1) = x(1);
path(i,2) = x(2);
while(norm(x1 - x,2) >0.01 && i <100)
    x1 = x;
    f = x - r*(H*x+b);
    xstar = quadprog(0.5*eye(2),-f, [], [], A, c, [0;0],[inf;inf],x);
  %  ix = find(xstar(1:2)<0); %no need to force the multiplier to be zero.
  %  xstar(ix) = 0;
    x = xstar;
    i = i + 1;
    path(i,1) = x(1);
    path(i,2) = x(2);
end

%definition of function myquad
function y = myquad(x)
y = 6*x(1)^2 + 5*x(2)^2;