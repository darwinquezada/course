function [results] = loadResults (myfolder,database,method,datarep,distance,k,rep)

fs = filesep();
load([ myfolder fs database fs method fs datarep '_' distance '_k' sprintf('%03d',k) fs 'results_rep' sprintf('%03d',rep) '.mat'], 'results');

endfunction
