function f=matfunc(expr,dummy,args)
% Function pour remplacer 'matlabfunction' sur les ancienne versions de 
% MATLAB
% 'dummy' est inutile, juste pour immiter la syntaxe de matlabfunction
% Fonction four une fonction "vectorielle" (pas "matricielle")

vchar = [];

for i=1:length(args)
    vchar = [vchar ',' char(args(i))];
end

vchar = ['@(' vchar(2:end) ')'];

charexpr = ['[' char(expr(1))];
for k=2:length(expr)
    charexpr = [charexpr '; ' char(expr(k))];
end

charexpr = [charexpr ']'];

fchar = ['f = ' vchar ' ' charexpr ';'];

f=0;

eval(fchar)
