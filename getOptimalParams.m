function [best_distance,best_rep,best_k,need_execution] = getOptimalParams (database,optionExec)

need_execution=1;

if optionExec == 1

best_distance = 'distance_euclidean'; best_rep='positive'; best_k=1;

elseif optionExec == 2

best_distance = 'distance_cityblock'; best_rep='positive'; best_k=1;

elseif optionExec == 3

if strcmp(database,'UJI1'); best_distance = 'distance_sorensen'; best_rep='powed'; best_k=11; end
if strcmp(database,'UJI2'); best_distance = 'distance_neyman'; best_rep='exponential'; best_k=11; end
if strcmp(database,'DSI1'); best_distance = 'distance_sorensen'; best_rep='powed'; best_k=11; end
if strcmp(database,'DSI2'); best_distance = 'distance_PLGD10'; best_rep='positive'; best_k=9; end
if strcmp(database,'LIB1'); best_distance = 'distance_squaredeuclidean'; best_rep='positive'; best_k=11; end
if strcmp(database,'LIB2'); best_distance = 'distance_PLGD10'; best_rep='positive'; best_k=9; end
if strcmp(database,'MAN1'); best_distance = 'distance_cityblock'; best_rep='exponential'; best_k=11; end
if strcmp(database,'MAN2'); best_distance = 'distance_neyman'; best_rep='exponential'; best_k=11; end
if strcmp(database,'TUT1'); best_distance = 'distance_PLGD40'; best_rep='positive'; best_k=3; end
if strcmp(database,'TUT2'); best_distance = 'distance_sorensen'; best_rep='powed'; best_k=1; end
if strcmp(database,'TUT3'); best_distance = 'distance_sorensen'; best_rep='positive'; best_k=3; end
if strcmp(database,'TUT4'); best_distance = 'distance_PLGD10'; best_rep='positive'; best_k=3; end
if strcmp(database,'TUT5'); best_distance = 'distance_PLGD40'; best_rep='positive'; best_k=3; end
if strcmp(database,'TUT6'); best_distance = 'distance_sorensen'; best_rep='positive'; best_k=1; end
if strcmp(database,'TUT7'); best_distance = 'distance_sorensen'; best_rep='positive'; best_k=1; end
if size(strfind(database,'SIM'),1); best_distance = 'distance_squaredeuclidean'; best_rep='exponential'; best_k=11; end

elseif optionExec == 4


best_distance = 'distance_squaredeuclidean';
best_rep      = 'positive';
if strcmp(database,'UJI1'); best_k=11; end
if strcmp(database,'UJI2'); best_k=11; end
if strcmp(database,'DSI1'); best_k=11; end
if strcmp(database,'DSI2'); best_k=11; end
if strcmp(database,'LIB1'); best_k=11; end
if strcmp(database,'LIB2'); best_k=11; end
if strcmp(database,'MAN1'); best_k=11; end
if strcmp(database,'MAN2'); best_k=11;end
if strcmp(database,'TUT1'); best_k=5;  end
if strcmp(database,'TUT2'); best_k=3; end
if strcmp(database,'TUT3'); best_k=3;  end
if strcmp(database,'TUT4'); best_k=3; end
if strcmp(database,'TUT5'); best_k=3; end
if strcmp(database,'TUT6'); best_k=1; end
if strcmp(database,'TUT7'); best_k=1; end
if size(strfind(database,'SIM'),1); best_k=11;end

elseif optionExec == 5

if strcmp(database,'UJI1'); best_distance = 'distance_PLGD10'; best_rep='positive'; best_k=9; end
if strcmp(database,'UJI2'); best_distance = 'distance_PLGD10'; best_rep='positive'; best_k=11; end
if strcmp(database,'DSI1'); best_distance = 'distance_sorensen'; best_rep='positive'; best_k=9; end
if strcmp(database,'DSI2'); best_distance = 'distance_PLGD10'; best_rep='positive'; best_k=9; need_execution=0; end
if strcmp(database,'LIB1'); best_distance = 'distance_squaredeuclidean'; best_rep='positive'; best_k=11; need_execution=0; end
if strcmp(database,'LIB2'); best_distance = 'distance_PLGD10'; best_rep='positive'; best_k=9;need_execution=0; end
if strcmp(database,'MAN1'); best_distance = 'distance_sorensen'; best_rep='positive'; best_k=11; end
if strcmp(database,'MAN2'); best_distance = 'distance_squaredeuclidean'; best_rep='positive'; best_k=11; end
if strcmp(database,'TUT1'); best_distance = 'distance_PLGD40'; best_rep='positive'; best_k=3; need_execution=0; end
if strcmp(database,'TUT2'); best_distance = 'distance_PLGD40'; best_rep='positive'; best_k=7; end
if strcmp(database,'TUT3'); best_distance = 'distance_sorensen'; best_rep='positive'; best_k=3; need_execution=0; end
if strcmp(database,'TUT4'); best_distance = 'distance_PLGD10'; best_rep='positive'; best_k=3; need_execution=0;end
if strcmp(database,'TUT5'); best_distance = 'distance_PLGD40'; best_rep='positive'; best_k=3; need_execution=0;end
if strcmp(database,'TUT6'); best_distance = 'distance_sorensen'; best_rep='positive'; best_k=1; need_execution=0;end
if strcmp(database,'TUT7'); best_distance = 'distance_sorensen'; best_rep='positive'; best_k=1;need_execution=0; end
if size(strfind(database,'SIM'),1); best_distance = 'distance_cityblock'; best_rep='positive'; best_k=11;end


end
