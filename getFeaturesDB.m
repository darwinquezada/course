function features = getFeaturesDB( database ) 
  
  fs = filesep();
  if strcmp(database,'SIM')
    load(['databases' fs database '001.mat'])
  else
    load(['databases' fs database '.mat'])
  end
  
  features.rsamples = size(database.trainingMacs,1);
  features.osamples = size(database.testMacs,1);
  features.nmacs    = size(database.testMacs,2);
  
end
