function newp = integrate_var(p, old, mom_handle)
% @MPOL/INTEGRATE_VAR integrates out variables in a given polynomial
%
% SUBS(P, OLD, MOM_HANDLE) given the variable P of type mpol, integrates
%   the variable (or vector of variables) OLD with the moments supplied by
%   MOM_HANDLE
%
% p --> Int_old p(old, other_vars) d old, where mom_handle is a function
% [multi-index]->real number (moment)

% J. Miller, 23 May, 2023
%
%code and documentation based on @MPOL/SUBS: 
% C. Savorgnan, 14 May 2008
% modified by D. Henrion, 13 July 2020

if ~isvector(old)
    error('the second argument must be a vector of variables of type mpol');
end

for index = 1:length(old)
    if ~isa(old(index), 'mpol') || ~isvar(old(index))
        error('the second argument must be a vector of variables of type mpol');
    end
end

% if ~isvector(new)
%     error('the third argument must be a vector of variables of type mpol or a numeric vector');
% end
% 
% if ~isa(new, 'mpol') && ~isnumeric(new)
%     error('the third argument must be a vector of variables of numeric or mpol type');
% end
% 
% if length(old)~=length(new)
%     error('the second and third argument must have equal size');
% end

if ~(isa(mom_handle,'function_handle'))
    error('the third argument must be a moment function handle');
end

[nrows, ncols] = size(p);

%substitution

newp = p;

v_old = indvar(old);
if ~isnumeric(p)
for rind = 1:nrows
    for cind = 1:ncols
        var = listvar(p(rind, cind));
        pow = p(rind, cind).pow;
        coef = p(rind, cind).coef;
        newp(rind, cind) = mpol(0);
        for mind = 1:length(coef) % for all the monomials in p(rind, cind)
            tmp = coef(mind);
            d_curr = zeros(size(v_old))';
            vc = 1;
            for vind = 1:length(var) % for all the variables in p(rind, cind)
                ind = locate(old, var(vind));
%                   ind = find(v_old == vind);
                if isempty(ind)
                    tmp = tmp * var(vind)^pow(mind, vind);
                else
%                     tmp = tmp * new(ind)^pow(mind, vind);
                    d_curr(vc) = pow(mind, vind);
                    vc = vc + 1;
                end                
            end
            mom_curr = mom_handle(d_curr);
            newp(rind, cind) = newp(rind, cind) + mom_curr*tmp;
        end
    end
end
end