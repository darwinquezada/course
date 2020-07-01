function distances = distance_sorensen(p,q,~)

distances = sum(abs(p-q)) / sum(p+q);

return