function [ results ] = knn_moreira( database_orig , k, datarep, defaultNonDetectedValue, newNonDetectedValue , distanceMetric )
% knn_ips Indoor Positioning System based on kNN
% using the optimization rule based on Moreira
% the reduced radio map contains all the reference
% samples where the valid strongest AP in the 
% operational fingerprint is detected with a valid 
% RSSI
%
% A. Moreira, M. J. Nicolau, F. Meneses, et al., 
% “Wi-fi fingerprinting in the real world - RTLS@UM 
% at the EvAAL competition,” in 2015 International 
% Conference on Indoor Positioning and Indoor
% Navigation (IPIN), IEEE, Oct. 2015.
%   
% inputs: 
%    database_orig           : database with RSSI values and Labels
%    k                       : value of nearest neighbors in kNN algoritm
%    datarep                 : Data representation
%    defaultNonDetectedValue : Value in DB for non detected RSSI values
%    newNonDetectedValue     : New Value for non detected RSSI values
%    distanceMetric          : Distance metric used for FP matching
%
% output:
%    results                 : output statistics
%
% Developed by J. Torres-Sospedra,
% Instiute of New Imaging Technologies, Universitat Jaume I
% jtorres@uji.es

ticT1m3 = myTic();
% Remap bld numbers to 1:nblds
origBlds = unique((database_orig.trainingLabels(:,5))); 
nblds    = size(unique(origBlds),1);
database0  = remapBldDB(database_orig,origBlds',1:nblds);

% Remap floors numbers to 1:nfloors
origFloors = unique((database_orig.trainingLabels(:,4))); 
nfloors    = size(unique(origFloors),1);
database0  = remapFloorDB(database0,origFloors',1:nfloors);

% Calculate the overall min RSSI (minus 1)
if size(newNonDetectedValue,1) == 0
newNonDetectedValue = min(...
                     [database0.trainingMacs(:)',...                      
                      database0.testMacs(:)']...
                     )-1;
end

% Replace NonDetectedValue
if size(defaultNonDetectedValue,1) ~= 0
    database0 = datarepNewNullDB(database0,defaultNonDetectedValue,newNonDetectedValue);
end
database_predata = database0;
% Apply new data representation                 
if  strcmp(datarep,'positive') % Convert negative values to positive by adding a value
    database  = datarepPositive(database0);
  
    if or(strcmp(distanceMetric,'distance_cramariucPLGD40'),strcmp(distanceMetric,'distance_cramariucPLGD40'))
      additionalparams = -85 - newNonDetectedValue;
    else
      additionalparams = 0;
    end
    
elseif strcmp(datarep,'exponential') % Convert to exponential data representation
    %database0 = datarepPositive(database0);
    database  = datarepExponential(database0);
    
    if or(strcmp(distanceMetric,'distance_cramariucPLGD40'),strcmp(distanceMetric,'distance_cramariucPLGD40'))
      additionalparams =  exp(((-85-newNonDetectedValue))/24)./exp((-newNonDetectedValue)/24);
    else
      additionalparams = 0;
    end
    
elseif strcmp(datarep,'powed') % Convert to powed data representation
    %database0 = datarepPositive(database0); 
    database  = datarepPowed(database0);  
    
    if or(strcmp(distanceMetric,'distance_cramariucPLGD40'),strcmp(distanceMetric,'distance_cramariucPLGD40'))
      additionalparams =  ((-85-newNonDetectedValue).^exp(1))./((-newNonDetectedValue).^exp(1));
    else
      additionalparams = 0;
    end
      
end % Default, no conversion

clear database0;
   
% Get number of samples
rsamples = size(database.trainingMacs,1); 
osamples = size(database.testMacs,1);
nmacs    = size(database.testMacs,2);

% Prepare output vectors
results.error      = zeros(osamples,5);
results.prediction = zeros(osamples,5);
results.targets    = zeros(osamples,5);
results.candidates = zeros(osamples,1);
results.distances  = zeros(osamples,1);
results.timesample = zeros(osamples,5);
results.considered = zeros(osamples,5);

fprintf('\nRunning the %s algorithm with\n',mfilename)
fprintf('    database features      : [%d,%d,%d]\n',rsamples,osamples,nmacs)
fprintf('    k                      : %d\n',k)
fprintf('    datarep                : %s\n',datarep)
fprintf('    defaultNonDetectedValue: %d\n',defaultNonDetectedValue)
fprintf('    newNonDetectedValue    : %d\n',newNonDetectedValue)
fprintf('    distanceMetric         : %s\n',distanceMetric )

time00pre = myToc(ticT1m3);

database.trainingValidMacs = (database_orig.trainingMacs ~= defaultNonDetectedValue); 
database.testValidMacs     = (database_orig.testMacs     ~= defaultNonDetectedValue);


vecidxmacs    = 1:nmacs;
vecidxsamples = 1:rsamples;

database.trainingMaxMacs  = (database.trainingMacs == (max(database.trainingMacs')'*ones(1,nmacs)));

idxs                = cell(1,nmacs);
samplesStrongMac    = zeros(1,nmacs);
for i = vecidxmacs
  idxs(i) = {vecidxsamples(database.trainingMaxMacs(:,i)')};
  samplesStrongMac(i) =  size(idxs{i},2);
end

time00 = myToc(ticT1m3);


for i = 1:osamples  

    time01 = myToc(ticT1m3);
        
    ofp = database.testMacs(i,:);
	
	%% Moreira optimized
    [values,macorder] = sort(-ofp);    
    macorderFil = macorder((samplesStrongMac(macorder)>1));    
    considered = find(macorder == macorderFil(1));
      
	samples = unique(cell2mat( idxs(macorderFil(1)) ));
	
    if size(samples,1)==0   % If there is no sample in the reduced dataset -> original set
      considered = 0;  
      %samples = unique(cell2mat( idxs(vecidxmacs(macs)) )); optimization for advanced fengyou
      samples = 1:rsamples;      
    end
  
	  trainingMacs      = database.trainingMacs(samples,:);
	  trainingValidMacs = database.trainingValidMacs(samples,:);	
	  trainingLabels    = database.trainingLabels(samples,:);
	
	  rsamplesreduced = size(trainingMacs,1);
    
    ofp = database.testMacs(i,:);
    
    time02 = myToc(ticT1m3);
    
    distances = zeros(1,rsamplesreduced);
 
    for j = 1:rsamplesreduced;
        distances(j) = feval(distanceMetric,trainingMacs(j,:),ofp,additionalparams);
    end
           
    time03 = myToc(ticT1m3);
    % Sort distances
    [distancessort,candidates] = sort(distances);
    
    % Set the value of candidates to k (kNN)  <---- THIS IS NEW!!!!!!
    % MENTION IN THE PAPER
    ncandidates = min(k,rsamplesreduced);
    
    % Check if candidates ranked in positions higher than k have the same
    % distance in the feature space.
    while ncandidates < rsamplesreduced 
       if abs(distancessort(ncandidates)-distancessort(ncandidates+1))<0.000000000001
           ncandidates = ncandidates+1;
       else
           break
       end
    end

    % Estimate the building from the ncandidates
    probBld = zeros(1,nblds);
    for bld = 1:nblds
        probBld(bld) = sum(trainingLabels(candidates(1:ncandidates),5)==bld);
    end
    [~,bld] = max(probBld);
    
    % Estimate the floor from the ncandidates
    probFloor = zeros(1,nfloors);
    for floor = 1:nfloors
        probFloor(floor) = sum( (trainingLabels(candidates(1:ncandidates),4)==floor).*...
                                (trainingLabels(candidates(1:ncandidates),5)==bld));
    end
    [~,floor] = max(probFloor);
    
    % Estimate the coordinates from the ncandidates that belong to the
    % estimated floor
    points = 0;
    point  = [0,0,0];
    for j = 1:ncandidates
        if (trainingLabels(candidates(j),4)==floor).*(trainingLabels(candidates(j),5)==bld)
            points = points + 1;
            point  = point + trainingLabels(candidates(j),1:3);
        end
    end
    point = point / points;
    
    time04 = myToc(ticT1m3);
    % Extract the real-world bld (revert bld remap)
    realWorldBld = remapVector(bld,1:nblds,origBlds');
    
    % Extract the real-world floor (revert floor remap)
    realWorldFloor = remapVector(floor,1:nfloors,origFloors');
    
    % Generate the results statistics
    results.error(i,1) = distance_euclidean(database.testLabels(i,1:2),point(1:2)); % 2D Positioning error in m 
    results.error(i,2) = distance_euclidean(database.testLabels(i,1:3),point(1:3)); % 3D Positioning error in m
    results.error(i,3) = abs(database.testLabels(i,3)-point(3));                    % Height difference in m
    results.error(i,4) = abs(realWorldFloor - database_orig.testLabels(i,4));       % Height difference in floors
    results.error(i,5) = (realWorldBld ~= database_orig.testLabels(i,5));           % Building error
    
    results.prediction(i,:) = [point,realWorldFloor,realWorldBld];                  % Predicted position [x,y,z,floor]
    results.targets(i,:)    = database_orig.testLabels(i,1:5);                      % Current position   [x,y,z,floor]
    results.candidates(i,1) = ncandidates;                                          % Number of nearest neighbours used to estimate the position
    results.distances(i,1)  = distancessort(1);                                     % Distance in feature space of the best match
    
    results.samples(i,1)    = rsamplesreduced;         % Distance in feature space of the best match
    results.considered(i,1) = considered;              % Distance in feature space of the best match
    results.timesample(i,1) = time01;                  % Distance in feature space of the best match
    results.timesample(i,2) = time02;                  % Distance in feature space of the best match
    results.timesample(i,3) = time03;                  % Distance in feature space of the best match    
    results.timesample(i,4) = time04;                  % Distance in feature space of the best match    
    results.timesample(i,5) = myToc(ticT1m3);                     % Distance in feature space of the best match    
    
    time05 = myToc(ticT1m3);
	
end

results.timefull = [time00pre,time00,myToc(ticT1m3)];

fprintf('Successfully executed!\n')
fprintf('    Mean Positioning Error 2D*  : %3.3f\n',mean(results.error((results.error(:,4)==0),1)));  % Mean 2D Positioning error when estimate and true position are in the same floor
fprintf('    Mean Positioning Error 3D   : %3.3f\n',mean(results.error(:,2)));   
fprintf('    Mean Positioning Error EvAAL: %3.3f\n',mean(results.error(:,1)+4*results.error(:,4)+50*results.error(:,5)));                        % Mean 3D Positioning error
fprintf('    Mean Positioning Error IPIN : %3.3f\n',mean(results.error(:,1)+15*results.error(:,4)+50*results.error(:,5)));                        % Mean 3D Positioning error
fprintf('    Bld&Floor detection hit rate: %3.3f\n',mean((results.error(:,4)==0).*(results.error(:,5)==0))*100);                 % Floor detection rate
fprintf('    BD Preprocessing time       : %3.6f\n',time00);    
fprintf('    Average preprocessing time  : %3.6f\n',mean(results.timesample(:,2)-results.timesample(:,1)));    
fprintf('    Average matching time       : %3.6f\n',mean(results.timesample(:,3)-results.timesample(:,2)));    
fprintf('    Average positioning time    : %3.6f\n',mean(results.timesample(:,4)-results.timesample(:,3)));   
fprintf('    Full time                   : %3.6f\n',results.timefull(3)); 
fprintf('        DB Preprocessing        : %3.3f%%\n',results.timefull(1)/results.timefull(3)*100); 
fprintf('        FP Preprocessing        : %3.3f%%\n',sum(results.timesample(:,2)-results.timesample(:,1))/results.timefull(3)*100); 
fprintf('        Matching                : %3.3f%%\n',sum(results.timesample(:,3)-results.timesample(:,2))/results.timefull(3)*100); 
fprintf('        Positioning             : %3.3f%%\n\n',sum(results.timesample(:,4)-results.timesample(:,3))/results.timefull(3)*100); 