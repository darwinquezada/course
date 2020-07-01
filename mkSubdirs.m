function [stat, errmsg] = mkSubdirs (path)

cstr = strsplit ([path], filesep);
str = '';
parentDir = '.';

for is = 1:length(cstr)
    if is > 1
        parentDir = str;
    end
    str = [str, cstr{is}, '/'];
    [stat, errmsg] = mkdir(parentDir, cstr{is});
end




end
