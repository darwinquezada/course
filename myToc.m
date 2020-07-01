function [elapsedTime] = myToc(lastTicMeasuredTime)
  elapsedTime = cputime - lastTicMeasuredTime;
  %fprintf('Elapsed cpu time is %f seconds.\n',elapsedTime);
end