function [p_public] = get_representation(p, var)
%GET_REPRESENTATION Expose the representation of an mpol scalar to public
%access. This includes variable indices, power, coefficients



%tricky to address relevant variables
nvar = length(var);
varname_cell = cell(nvar, 1);
[varname_cell{:}] = var.var;
%permute input array in terms of gloptipoly's names of variables
[var_name_all, var_perm_all] = sort(cell2mat(varname_cell));

%current polynomial
curr_var = p.var;
curr_pow = p.pow;

%expand polynomial by adding entries for variables in vars not found in p
ind_var_found = ismember(var_name_all, curr_var);

all_pow = zeros(size(curr_pow, 1), nvar);
all_pow(:, ind_var_found) = curr_pow;

%package up the output
p_public = struct;
p_public.pow = all_pow;
p_public.coef = p.coef;
p_public.var = var_name_all;

end

