% Sort annotations from task4anns.mat into anns usable by GA

Anns = testAnns;
a = Anns{1};
t = Anns{2};

out = cell(1, 25942);
indx = 1;
anList = [];
%88 92 100
for i = 1:20 %[1:87, 89:91, 93:99, 101:109]
    sub = Anns{i};
    anList = [anList, getAnList(sub)];
end
    
    