%combineData;
meansleft = [];
meansright = [];
for sub = 1:109
    disp(sub)
    ex = squeeze(stream(sub, :, :));
    f0 = floor(7*80/129);
    fend = ceil(12*80/129);
    mu = [];
    for i = 1:1200
        t0 = (i-1)*16 + 1;
        tend = t0 + 80;
        freq = pwelch(ex(:, t0:tend)', 60, 45, 256, 160);
        mu = [mu; mean(freq(f0:fend, :))];
    end

    %%
    figure
    leftset = [1:3, 8:10, 15:17, 31:33, 48:50];
    rightset = [5:7, 12:14, 19:21, 35:37, 52:54];
    hold on
    meansleft = [meansleft, mean(mu(:, leftset), 2)];
    meansright = [meansright, mean(mu(:, rightset), 2)];
    
    plot(0:0.1:119.9, mean(mu(:, leftset), 2), 'b')
    plot(0:0.1:119.9, mean(mu(:, rightset), 2), 'r')

    ann = Anns{1, sub};
    ls = ann{1, 1};
    ts = ann{1, 2}/160;

    for i = 1:(length(ts) - 1)
        if ls{i} == 'T0'
            line([ts(i), ts(i)], [0, 0.025], 'color', 'b')
        elseif ls{i} == 'T1'
            line([ts(i), ts(i)], [0, 0.025], 'color', 'g')
        else
            line([ts(i), ts(i)], [0, 0.025], 'color', 'r')
        end
    end
end