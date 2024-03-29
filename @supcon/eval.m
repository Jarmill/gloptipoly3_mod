function [sc_eval, ineq, eq] = eval(sc, var, pt, tol)
% @SUPCON/EVAL Evaluate the support constraint at point pt
% 
% EVAL(SC, VAR, PTS) given the support constraint of SC of type supcon,
%   evaluate SC in variables VAR at point PT of type double
%
% INEQ: values of inequality constraints at PT (assumed >= 0)
% EQ:   values of equality constraints at PT
% tol: tolerance
%
% J. Miller, 22 July 2020

if nargin < 4
    tol = 1e-7;
end

npt = size(pt, 2);

%find types of constraints
nineq = 0;
neq = 0;
for i = 1:length(sc)
    if strcmp(sc(i).type, 'eq')
        neq = neq + 1;
    else
        nineq = nineq + 1;
    end
end

ineq = zeros(nineq, npt);
eq = zeros(neq, npt);

sc_eval = zeros(length(sc), npt);

if isa(pt, 'sym')
    sc_eval = sym(sc_eval);
    ineq = sym(ineq);
    eq = sym(eq);
end

for j = 1:npt
    %sc_subs = subs(sc, var, pt(:, j));
    
    dl = zeros(length(sc), 1);
    dr = zeros(length(sc), 1);
    
    if isa(pt, 'sym')
        dl = sym(dl);
        dr = sym(dr);
    end
    
    i_eq = 1;
    i_ineq = 1;
    for i = 1:length(sc)    
        type = sc(i).type;
        
        
        dl(i) = eval(sc(i).left, var, pt(:, j));
        dr(i)= eval(sc(i).right, var, pt(:, j));

        %dl = double(sc_subs(i).left);
        %dr = double(sc_subs(i).right);
        if strcmp(type, 'le')
%             sc_diff = dl(i) - dr(i);
            sc_eval(i, j) = (dl(i) <= dr(i)) || abs(dl(i) - dr(i)) <= tol;
%             sc_eval(i, j) = ((dl(i) - tol) <= dr(i));
            ineq(i_ineq, j) = dr(i) - dl(i);
            i_ineq = i_ineq + 1;
        elseif strcmp(type, 'ge')
%             sc_eval(i, j) = (dl(i) >= (dr(i) - tol));
%             sc_diff = dl(i) - dr(i);
            sc_eval(i, j) = (dl(i) >= dr(i)) || abs(dl(i) - dr(i)) <= tol;
            ineq(i_ineq, j) = dl(i) - dr(i);
            i_ineq = i_ineq + 1;
        else %equal
            sc_eval(i, j) = (abs(dl(i)-dr(i)) <= tol);
            eq(i_eq, j) = dl(i) - dr(i);
            i_eq = i_eq + 1;
        end
    end
end
end

