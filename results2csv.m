function accum = results2csv (method)

if ~exist('Results_CSV','dir')
  mkdir('Results_CSV');
end

resultsFolder = 'Results';


disp(['Showing results for ' method]);
fs = filesep();
databases = {'DSI1','DSI2','LIB1','LIB2','MAN1','MAN2','SIM','TUT1','TUT2','TUT3','TUT4','TUT5','TUT6','TUT7','UJI1','UJI2'};
databases_new = databases;

divisor = [];

accum_knn1m          = zeros(5,10,size(databases,1));
accum_best          = zeros(5,10,size(databases,1));
accum_knn1m_baseline = zeros(5,10,size(databases,1));
accum_best_baselome = zeros(5,10,size(databases,1));

for db = 1:size(databases,2)


  databasename = databases{db};

  rep0 = 10; 

  divisor = [divisor, rep0];

  for i = 1:rep0

    [distance,datarep,k,need_execution] = getOptimalParams (databases{db},2);
	  if strfind(databasename,'SIM')
      databasename = ['SIM',sprintf('%03d',i)];
	    results = loadResults(resultsFolder,databasename,method,datarep,strrep(distance,'distance_',''),k,1);
	  else
      results = loadResults(resultsFolder,databasename,method,datarep,strrep(distance,'distance_',''),k,i);
    end
    load(['databases' fs databasename '.mat']);
    accum_knn1m(:,i,db) = accumutateResults(database,results);


    [distance,datarep,k,need_execution] = getOptimalParams (databases{db},3);
	  if strfind(databasename,'SIM')
      databasename = ['SIM',sprintf('%03d',i)];
	    results = loadResults(resultsFolder,databasename,method,datarep,strrep(distance,'distance_',''),k,1);
	  else
      results = loadResults(resultsFolder,databasename,method,datarep,strrep(distance,'distance_',''),k,i);
    end
    load(['databases' fs databasename '.mat']);
    accum_best(:,i,db) = accumutateResults(database,results);



    [distance,datarep,k,need_execution] = getOptimalParams (databases{db},2);
	  if strfind(databasename,'SIM')
      databasename = ['SIM',sprintf('%03d',i)];
	    results = loadResults(resultsFolder,databasename,'knn_baseline',datarep,strrep(distance,'distance_',''),k,1);
	  else
      results = loadResults(resultsFolder,databasename,'knn_baseline',datarep,strrep(distance,'distance_',''),k,i);
    end
    load(['databases' fs databasename '.mat']);
    accum_knn1m_baseline(:,i,db) = accumutateResults(database,results);


    [distance,datarep,k,need_execution] = getOptimalParams (databases{db},3);
	  if strfind(databasename,'SIM')
      databasename = ['SIM',sprintf('%03d',i)];
	    results = loadResults(resultsFolder,databasename,'knn_baseline',datarep,strrep(distance,'distance_',''),k,1);
	  else
      results = loadResults(resultsFolder,databasename,'knn_baseline',datarep,strrep(distance,'distance_',''),k,i);
    end
    load(['databases' fs databasename '.mat']);
    accum_best_baseline(:,i,db) = accumutateResults(database,results);

  end


end



separator = '&';

%fprintf('%s','Database');
%fprintf('Database&\t%s&\t%s&\t%s&\t%s&\t%s&\t%s&\n',caption{8},['Normalized ' caption{8}],caption{24},['Normalized ' caption{24}],caption{8},['Normalized ' caption{8}],caption{24},['Normalized ' caption{24}]);
%fprintf('\\\\\n');

score_time = [0,0];
score_perf = [0,0];
score_fp   = [0,0];
score_norm = [0,0];

filename_1m   = ['Results_CSV/' method '_1m.csv'];
fidcsv_1m     = fopen(filename_1m,'w'); 
filename_best = ['Results_CSV/' method '_best.csv'];
fidcsv_best   = fopen(filename_best,'w');
%filename_best2 = ['csvresults/' resultsFolder '/' method '_best2.csv'];
%fidcsv_best2   = fopen(filename_best2,'w');

for db = 1:size(databases,2)
  fprintf('\\texttt{%s}',databases_new{db});

  normalize_error_1m   = (sum(accum_knn1m_baseline(1,:,db))/divisor(db));
  normalize_error_best = (sum(accum_knn1m_baseline(1,:,db))/divisor(db));
  %normalize_error_best2 = (sum(accum_best_baseline(8,:,db))/divisor(db));

  normalize_time_1m   = (sum(accum_knn1m_baseline(3,:,db))/divisor(db));
  normalize_time_best = (sum(accum_knn1m_baseline(3,:,db))/divisor(db));
  %normalize_time_best2 = (sum(accum_best_baseline(24,:,db))/divisor(db));

  [distance,datarep,k,need_execution] = getOptimalParams (databases{db},2);
  %fprintf('%s\\{k=%d,%s,%s\\}',separator,k,distance,datarep);

	fprintf(['%s%8.2f'],separator,sum(accum_knn1m(1,:,db))/divisor(db))
  fprintf(['%s%8.2f'],separator,(((sum(accum_knn1m(1,:,db))/divisor(db))/normalize_error_1m)))
  fprintf(['%s%8.2f'],separator,sum(accum_knn1m(3,:,db))/divisor(db))
  %fprintf(['%s%8.2f'],separator,sum(accum_knn1m(24,:,db))/divisor(db)/accum_best(2,1,db))
  fprintf(['%s%8.2f'],separator,(((sum(accum_knn1m(3,:,db))/divisor(db))/normalize_time_1m)))

  fprintf(fidcsv_1m,'%s',databases_new{db});
  fprintf(fidcsv_1m,['%s%8.4f'],',',(((sum(accum_knn1m(1,:,db))/divisor(db))/normalize_error_1m)))
  fprintf(fidcsv_1m,['%s%8.4f'],',',(((sum(accum_knn1m(3,:,db))/divisor(db))/normalize_time_1m)))
  fprintf(fidcsv_1m,['%s%8.4f'],',',(((sum(accum_knn1m(1,:,db))/divisor(db)))))
  fprintf(fidcsv_1m,['%s%8.4f'],',',(((sum(accum_knn1m(3,:,db))/divisor(db)))))
  fprintf(fidcsv_1m,'\n')
  
  [distance,datarep,k,need_execution] = getOptimalParams (databases{db},3);
    distance = strrep(distance,'distance_','');
    distance = strrep(distance,'cramariuc','');
    distance = strrep(distance,'g3_','');
    distance = strrep(distance,'euclidean','euclid');
    datarep  = strrep(datarep,'itive','');
    datarep  = strrep(datarep,'onential','');
    datarep  = strrep(datarep,'ed','');
  %fprintf('%s\\{k=%d,%s,%s\\}',separator,k,distance,datarep)

	fprintf(['%s%8.2f'],separator,sum(accum_best(1,:,db))/divisor(db))
  fprintf(['%s%8.2f'],separator,(((sum(accum_best(1,:,db))/divisor(db))/normalize_error_best)))
  fprintf(['%s%8.2f'],separator,sum(accum_best(3,:,db))/divisor(db))
  %fprintf(['%s%8.2f'],separator,sum(accum_best(24,:,db))/divisor(db)/accum_best(2,1,db))
 	fprintf(['%s%8.2f'],separator,(((sum(accum_best(3,:,db))/divisor(db))/normalize_time_best)))
  fprintf('\\\\\n');
  
  fprintf(fidcsv_best,'%s',databases_new{db});
  fprintf(fidcsv_best,['%s%8.4f'],',',(((sum(accum_best(1,:,db))/divisor(db))/normalize_error_best)))
  fprintf(fidcsv_best,['%s%8.4f'],',',(((sum(accum_best(3,:,db))/divisor(db))/normalize_time_best)))
  fprintf(fidcsv_best,['%s%8.4f'],',',(((sum(accum_best(1,:,db))/divisor(db)))))
  fprintf(fidcsv_best,['%s%8.4f'],',',(((sum(accum_best(3,:,db))/divisor(db)))))
  fprintf(fidcsv_best,'\n')

  %fprintf(fidcsv_best2,'%s',databases_new{db});
  %fprintf(fidcsv_best2,['%s%8.4f'],',',(((sum(accum_best(8,:,db))/divisor(db))/normalize_error_best2)))
  %fprintf(fidcsv_best2,['%s%8.4f'],',',(((sum(accum_best(24,:,db))/divisor(db))/normalize_time_best2)))
  %fprintf(fidcsv_best2,['%s%8.4f'],',',(((sum(accum_best(8,:,db))/divisor(db)))))
  %fprintf(fidcsv_best2,['%s%8.4f'],',',(((sum(accum_best(24,:,db))/divisor(db)))))
  %fprintf(fidcsv_best2,'\n')
  
  score_time(1) = score_time(1) + accum_knn1m(2,1,db)*(((sum(accum_knn1m(3,:,db))/divisor(db))/normalize_time_1m));
  score_perf(1) = score_perf(1) + accum_knn1m(2,1,db)*(((sum(accum_knn1m(1,:,db))/divisor(db))/normalize_error_1m));
  %score_fp(1)   = score_fp(1)   + accum_knn1m(2,1,db)*(((sum(accum_knn1m(36,:,db))/divisor(db))/accum_knn1m(1,1,db)));
  score_norm(1) = score_norm(1) + accum_knn1m(2,1,db);

  score_time(2) = score_time(2) + accum_best(2,1,db)*(((sum(accum_best(3,:,db))/divisor(db))/normalize_time_1m));
  score_perf(2) = score_perf(2) + accum_best(2,1,db)*(((sum(accum_best(1,:,db))/divisor(db))/normalize_error_1m));
  %score_fp(2)   = score_fp(2)   + accum_best(2,1,db)*(((sum(accum_best(36,:,db))/divisor(db))/accum_best(1,1,db)));
  score_norm(2) = score_norm(2) + accum_best(2,1,db);

end
fclose all;
endfunction
