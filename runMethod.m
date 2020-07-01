


function  runMethod (databaseName,datarep,clustering,distanceMetric,k,repetitions,k2,labelk2,rho,labelrho)
  
  if exist('OCTAVE_VERSION', 'builtin') ~= 0;
    saveOption = '-mat7-binary';
  else
    saveOption = '-mat';
  end

  
  sep = filesep();
  
  database = loadDatabase('databases',databaseName);
  defaultNonDetectedValue = 100; 
  newNonDetectedValue     = min([database.trainingMacs(:);database.testMacs(:)]) - 1;
  
  
  
  for i = repetitions
    
    fprintf('%s -- %s repetition %d of %d',clustering,databaseName,i,repetitions(end));
    
    if strcmp(clustering,'knn_baseline') || strcmp(clustering,'knn_moreira') || strcmp(clustering,'knn_gallagher')             
      % knn method with RSSI based rules (Moreira & Gallagher)
      
      results  = feval(clustering, database , k, datarep, ...
      defaultNonDetectedValue, newNonDetectedValue , ...
      distanceMetric );  
      
      folderResults = ['Results' sep databaseName sep clustering sep  datarep '_' strrep(distanceMetric,'distance_','') '_k' sprintf('%03d',k)] ;

    elseif   size(strfind(clustering,'knn_kmeans'),1)
      % knn with clustering (2-step search) - k-means (it requires to set the number of clusters)
      
      % Since the process to compute the clusters is demanding, we asumed that are stored in the knn method for its reuse in re-runnings
      folderClusters = ['Clusters' sep databaseName sep 'knn_kmeans' sep] ;
      
      if ~size(strfind(clustering,'variant'),1) % Original Clustering method
        [results,clusters]  = feval(clustering, database , k, datarep, ...
        defaultNonDetectedValue, newNonDetectedValue , ...
        distanceMetric, k2 , i, labelk2, folderClusters);  
        folderResults = ['Results' sep databaseName sep clustering '_k' labelk2 sep datarep '_' strrep(distanceMetric,'distance_','') '_k' sprintf('%03d',k)] ;
        
      else                              % Improved Clustering method (Variants 1, 2, 3...)
        [results,clusters]  = feval(clustering, database , k, datarep, ...
        defaultNonDetectedValue, newNonDetectedValue , ...
        distanceMetric, k2 , i, labelk2, folderClusters,rho,labelrho);  
        folderResults = ['Results' sep databaseName sep clustering '_k' labelk2 '_rho' labelrho sep datarep '_' strrep(distanceMetric,'distance_','') '_k' sprintf('%03d',k)] ;
      end
      
    end
    
    
    if ~exist(folderResults)
      mkSubdirs(folderResults);
    end
    save([folderResults sep 'results_rep' sprintf('%03d',i) '.mat' ],'results',saveOption)


  end
  
