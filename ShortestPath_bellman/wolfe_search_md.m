function [alpha,fval,nfe,nde] = ...
    wolfe_search_md(f,df,x0,p,alpha0,c1,c2,fx0,dfx0,trace)
% [alpha,fval,nfe,nde] = ...
%	wolfe_search(f,dphi,x0,p,alpha0,c1,c2,fx0,dfx0,trace)
% Performs search for point satisfying the two strong Wolfe conditions:
%
%	f(x0+alpha*p) <= f(x0) + c1alpha*p'df(x0)	(WC1)
%	|p'*df(x0+alpha*p)| <= c2|p'*df(x0)|    	(WC2b)
%
% alpha0 is the initial value of alpha in the search.  If alpha0
%	satisfies the Wolfe conditions, then the search stops there. 
% fx0 is f(x0).
% dfx0 is df(x0).
% df(x) is the gradient of f(x) with
% If trace is non-zero then print out information about the process
%
% The algorithm follows that of Wright & Nocedal "Numerical Optimization",
% pp. 60-62, section 3.4
%
% Returns
%	alpha	-- step length parameter
%	fval	-- function value at end
%	dfval	-- gradient value at end
%	nfe	-- # function evaluations
%	nde	-- # gradient evaluations

% Initialization
nfe = 0;
nde = 0;
if nargin <= 8
  trace = 0;
end
%
% Check parameters
%
if ~ ( 0 < c1 & c1 < c2 & c2 < 1 )
  fprintf('wolfe_search_md: Error: Need 0 < c1 < c2 < 1\n');
  if trace ~= 0
    fprintf('wolfe_search_md: c1 = %g, c2 = %g\n', c1, c2);
  end
  alpha = 0;
  fval = fx0;
  return
end

if p'*dfx0 >= 0
  fprintf('wolfe_search_md: Error: Need a descent direction\n');
  if trace ~= 0
    fprintf('wolfe_search_md: phi''(0) = %g\n',p'*dfx0);
  end
  alpha = 0;
  fval = fx0;
  return
end

%
% Bracketing phase
%
if trace ~= 0
  fprintf('wolfe_search_md: Bracketing phase: alpha = %g\n', alpha0);
end
alpha = alpha0;
old_alpha = 0;
%phi0  = feval(phi, params,0);
%dphi0 = feval(dphi,params,0);
old_fval = fx0;
old_dfval = dfx0;
if trace ~= 0
  fprintf('wolfe_search_md: phi(0) = %g, phi''(0) = %g\n',fx0,p'*dfx0);
end

% Main loop
firsttrip = 1;
while 1 %%% forever do
  fval = feval(f,x0+alpha*p);
  nfe = nfe + 1;
  if trace ~= 0
    fprintf('wolfe_search_md: alpha = %g, phi(alpha) = %g\n', alpha, ...
	fval);
  end
  if ( ( fval > fx0 + c1*alpha*p'*dfx0 ) | ...
		( ( ~ firsttrip ) & ( fval >= old_fval ) ) )
	    if trace ~= 0
	      fprintf('wolfe_search_md: (WC1) failed or f increased\n');
	    end
    break;
  end
  if trace ~= 0
    fprintf('wolfe_search_md: (WC1) holds & f decreased\n');
  end
  dfval = feval(df,x0+alpha*p);
  nde = nde + 1;
  if trace ~= 0
    fprintf('wolfe_search_md: phi''(alpha) = %g\n', p'*dfval);
  end
  if ( abs(p'*dfval) <= c2*abs(p'*dfx0) )
    if trace ~= 0
      fprintf('wolfe_search_md: (WC2) holds\n');
    end
    return
  end
  if ( p'*dfval >= 0 )
    if trace ~= 0
      fprintf('wolfe_search_md: phi''(alpha) >= 0\n');
    end
    break;
  end

  % Update variables -- note no upper limit on alpha
  temp = alpha;
  % alpha = alpha + old_alpha;
  alpha = 2*alpha;
  old_alpha = temp;
  old_fval = fval;
  old_dfval = dfval;
end

%
% "Zoom" phase
%
alpha_lo = old_alpha;
alpha_hi =     alpha;
f_lo   = old_fval;
f_hi   =     fval;
df_lo  = old_dfval;

if trace ~= 0
  fprintf('wolfe_search_md: zoom phase: alpha_lo = %g, alpha_hi = %g\n', ...
      alpha_lo, alpha_hi);
end

iter_cnt = 0;
while 1 %%% forever do...

  % form quadratic interpolant of function values on alpha_lo, alpha_hi
  % and the derivative at alpha_lo...
  % and find min of interpolant within interval [alpha_lo,alpha_hi]
  a = f_lo;
  b = p'*df_lo;
  dalpha = alpha_hi-alpha_lo;
  c = (f_hi - f_lo - dalpha*b)/dalpha^2;
  % iter_cnt
  if ( ( c <= 0 ) | ( mod(iter_cnt,3) == 2 ) )
    % Use bisection
    alpha = alpha_lo + 0.5*dalpha;
    if trace ~= 0
      fprintf('wolfe_search_md: using bisection: c=%g\n', c);
    end
  else
    % Use min of quadratic
    alpha = alpha_lo - 0.5*b/c;
    if trace ~= 0
      fprintf('wolfe_search_md: using quadratic: a=%g, b=%g, c=%g\n', a, b, c);
    end
  end
  if trace ~= 0
    fprintf('wolfe_search_md: alpha = %g\n', alpha);
  end

  % main part of loop
  fval = feval(f,x0+alpha*p);
  nfe = nfe + 1;
  if trace ~= 0
    fprintf('wolfe_search_md: phi(alpha) = %g\n', fval);
  end
  if ( ( fval > fx0 + c1*alpha*p'*dfx0 ) | ( fval >= f_lo ) )
    if trace ~= 0
      fprintf('wolfe_search_md: zoom: (WC1) fails or phi increased\n');
      fprintf('wolfe_search_md: zoom: update alpha_hi\n');
    end
    alpha_hi = alpha;
    f_hi   = fval;
    % dphi_hi = feval(dphi,params,alpha);
  else
    if trace ~= 0
      fprintf('wolfe_search_md: zoom: (WC1) holds and phi decreased\n');
    end
    dfval = feval(df,x0+alpha*p);
    nde = nde + 1;
    if trace ~= 0
      fprintf('wolfe_search_md: phi''(alpha) = %g\n', p'*dfval);
    end
    if ( abs(p'*dfval) <= c2*abs(p'*dfx0) )
      if trace ~= 0
	fprintf('wolfe_search_md: zoom: (WC2b) holds\n');
      end
      return
    end
    if ( p'*dfval*dalpha >= 0 )
      if trace ~= 0
	fprintf('wolfe_search: zoom: alpha_hi <- alpha_lo & update alpha_lo\n');
      end
      alpha_hi = alpha_lo;
      f_hi   = f_lo;
      % dphi_hi = dphi_lo;
      alpha_lo = alpha;
      f_lo   = fval;
      df_lo  = dfval;
    else
      if trace ~= 0
	fprintf('wolfe_search_md: zoom: update alpha_lo\n');
      end
      alpha_lo = alpha;
      f_lo   = fval;
      df_lo  = dfval;
    end
  end
  % Update iteration count
  iter_cnt = iter_cnt + 1;

end % of forever do...

