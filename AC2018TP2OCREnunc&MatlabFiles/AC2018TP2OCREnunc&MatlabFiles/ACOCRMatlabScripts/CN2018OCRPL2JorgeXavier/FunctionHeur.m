% Função heuristica que vai tornar o valor máximo de cada coluna em 1 e o
% resto dos valores em 0
function output = FunctionHeur(matrix)
    [maximum,index]=max(matrix);
    output = zeros(size(matrix,1),size(matrix,2));
    for i=1:size(output,1)
        for j=1:size(output,2)
            for c=1:length(index)
                if j==c && i==index(c)
                    output(i,j)=1;
                end
            end
        end
    end
end
                      
                 