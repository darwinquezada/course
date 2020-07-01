clear;clc;pack; more off;

close all;
fclose all;

databases       = {'DSI1','DSI2','LIB1','LIB2','MAN1','MAN2','SIM','TUT1','TUT2','TUT3','TUT4','TUT5','TUT6','TUT7','UJI1','UJI2'};
models          = {'knn_baseline','knn_moreira','knn_gallagher'};
variants        = {'_variant01', '_variant02', '_variant03'};
rhovalues       = [0,3,6,9,12];

fid_script_mo= fopen('executeSample.m','w');

file_id  = 1;


for repetition = 1:10
  
  repetition 
  
  for db = 1:size(databases,2)
    
    currentDatabase   = databases{db};
    currentRepetition = repetition;
    if strfind(currentDatabase,'SIM')
      currentDatabase   = [currentDatabase sprintf('%03d',repetition) ];
      currentRepetition = 1;
    end      
    
    for i=[3]
      
      features = getFeaturesDB(databases{db});  
      [best_distance,best_rep,best_k,need_execution] = getOptimalParams (databases{db},i);

      % Baseline      
      fprintf(fid_script_mo,"runMethod('%s','%s','%s','%s',%d,%d);\n",currentDatabase,best_rep,'knn_baseline',best_distance,best_k,currentRepetition);

      % KNN Variants
      clustering = 'knn_kmeans';
      
      variant = 1; rhovalue = 3;  
      fprintf(fid_script_mo,"runMethod('%s','%s','%s','%s',%d,%d,%d,'%s',%d,'%s');\n",currentDatabase,best_rep,[clustering,variants{variant}],best_distance,best_k,currentRepetition,round(sqrt(features.rsamples)) ,'rfp1',rhovalues(rhovalue),sprintf('%02d',rhovalues(rhovalue)));
      
      variant = 2; rhovalue = 4;      
      fprintf(fid_script_mo,"runMethod('%s','%s','%s','%s',%d,%d,%d,'%s',%d,'%s');\n",currentDatabase,best_rep,[clustering,variants{variant}],best_distance,best_k,currentRepetition,round(sqrt(features.rsamples)) ,'rfp1',rhovalues(rhovalue),sprintf('%02d',rhovalues(rhovalue)));
          
      variant = 3; rhovalue = 5;             
      fprintf(fid_script_mo,"runMethod('%s','%s','%s','%s',%d,%d,%d,'%s',%d,'%s');\n",currentDatabase,best_rep,[clustering,variants{variant}],best_distance,best_k,currentRepetition,round(features.rsamples/25)    ,'rfp2',rhovalues(rhovalue),sprintf('%02d',rhovalues(rhovalue)));
      
    end
    
  end
  
end



fclose all;
