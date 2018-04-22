clear;
load('Task4Data.mat')

%% sample from 20 subjects over 30 seconds for 15 ICs
for i = 1:20
    disp('Subject:')
    disp(i)
    for j = 1:5
        disp('Sample:')
        disp(j)
        data = squeeze(record(i, 1:64, (j*5*160):((j*5+5)*160)));
        [S, W] = ICA(data, 15);
        Sfull(i, j, :, :) = S;
        Wfull(i, j, :, :) = W;
    end
end

%%
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
   N = size(data,2);

   label = [];
for subject = 1:20
    for sample = 1:5
        for c = 1:15
            str = sprintf('Subject: %d, sample: %d, component: %d', subject, sample, c);
            disp(str)
            clf
            subplot(2, 2, [1 3])
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

            subplot(2, 2, 2)
            plot(0:1/160:5, S)
            title('Time Response')
            xlabel('Time (in seconds)')
            xlim([0 5])

            subplot(2, 2, 4)
            % Fourier Transform:
           X = fftshift(fft(S));
           % Frequency specifications:
           dF = Fs/N;                      % hertz
           f = -Fs/2:dF:Fs/2-dF;           % hertz
           plot(f(ceil(length(f)/2):end),abs(X(ceil(length(f)/2):end))/N);
           xlabel('Frequency (in hertz)');
           xlim([0 70])
           title('Frequency Response');

           in = input('Artefact?\n', 's');
           if isempty(in)
               label = [label 'N'];
           else
               label = [label 'A'];
           end
        end
    end
end
