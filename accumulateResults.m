
function [accum] = accumulateResults (database, results)

    j= 0;
    errorvector = results.prediction - results.targets;
    j=j+1;accum(j) = mean(sqrt(errorvector (:,1).^2 + errorvector (:,2).^2 + errorvector (:,3).^2)); % Mean 3D Error (m)
    j=j+1;accum(j) = results.timefull(3)-results.timefull(2);    
    j=j+1;accum(j) = sum(results.timesample(:,4)-results.timesample(:,1)); 
    j=j+1;accum(j) = mean(results.timesample(:,4)-results.timesample(:,1));    
    j=j+1;accum(j) = std(results.timesample(:,4)-results.timesample(:,1));  

    
endfunction
