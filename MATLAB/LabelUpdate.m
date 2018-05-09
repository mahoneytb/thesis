% Quickly search through training set to verify labels
clear
load('testS.mat')
load('testW.mat')
load('filterLabelsNew.mat')

clf
hold on
brain = imread('64ChEEG.png');
image(brain);

coords = [179, 227; 220, 230; 259, 234; 300, 235; 344, 235; 383, 229; 423, 226; ...
            174, 279; 216, 279; 259, 279; 301, 279; 344, 277; 388, 279; 429, 279; ...
            178, 328; 219, 326; 258, 322; 300, 321; 343, 322; 383, 325; 424, 328; ...
            250, 107; 301, 101; 353, 107; 199, 135; 242, 147; 301, 144; 361, 143; ...
            404, 133; 163, 171; 193, 180; 230, 186; 267, 186; 302, 188; 336, 185; ...
            372, 185; 407, 182; 441, 170; 140, 219; 462, 218; 130, 278; 473, 278; ...
            89, 277; 513, 278; 139, 335; 464, 335; 162, 383; 194, 373; 230, 370; ...
            268, 368; 301, 367; 335, 367; 372, 369; 409, 375; 441, 382; 199, 419; ...
            241, 412; 300, 414; 362, 412; 405, 417; 250, 449; 301, 459; 352, 447; ...
            300, 504];

[xi yi] = meshgrid(1:540, 1:600);

% Time specifications:
Fs = 160;                      % samples per second
dt = 1/Fs;                     % seconds per sample
StopTime = 5;                  % seconds
t = (0:dt:StopTime-dt)';
N = 321;               % 321

% Plot the ICA
% subject 7 sample 3 component 3
count = 1;
subCount = 1;
for subject = 1:20
    for sample = 1:10
        for c = 1:15
            if count > 2480 %Skip to here
                if newLabel(count) == 'N'
                    image(brain);
                    hold on
                    W = squeeze(Wfull(subject, sample, :, c));
                    S = squeeze(Sfull(subject, sample, c, :));
                    if min(W) < 0
                    plotW = W + abs(min(W));
                    else
                    plotW = W - min(W);
                    end
                    plotW = plotW * 255 / max(plotW);

                    scatter(coords(:, 1), coords(:, 2), 20, 'MarkerEdgeColor',[0 .5 .5],...
                          'MarkerFaceColor',[0 .7 .7], 'LineWidth',2)
                    zi = griddata(coords(:, 1), coords(:, 2), plotW(:, 1), xi, yi);
                    h = surfc(xi, yi, zi, 'FaceAlpha',0.7, 'LineStyle','none', 'FaceColor', 'flat');
                    set(gca,'YTickLabel',[]);
                    set(gca,'XTickLabel',[]);
                    colormap(jet);
                    title(count)

                    in = input('Artefact?\n', 's');
                    clf
                end
            end
            count = count + 1;
        end
    end
end