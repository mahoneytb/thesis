% Detect artefacts and remove
for subject = 93:109
    if subject ~= 88
        for sample = 1:240
            fprintf('Subject: %d Sample: %d\n', subject, sample);
            for c = 1:15
                W = squeeze(Wfull(subject, sample, :, c));
                S = squeeze(Sfull(subject, sample, c, :));
                features = getFeatures(W, S);
                y = bestNet(features);
                if y(2) > y(1)
                    SfullRemoved(subject, sample, c, :) = 0;
                    count = count + 1;
                end
            end
            fprintf('Removed %d artefacts\n', count)
            artefactsRemoved = [artefactsRemoved, count];
            count = 0;
        end
    end
end

%%

x = pinv(squeeze(Wfull(1, 4, :, :)))'*squeeze(Sfull(1, 4, :, :));
xfilt = pinv(squeeze(Wfull(1, 4, :, :)))'*squeeze(SfullRemoved(1, 4, :, :));

figure()
for i = 1:16
    subplot(8, 2, i)
    hold on
    plot(x(i,:))
    plot(xfilt(i,:))
end

%% Convert S and W back to x
% subjects 88, 92 and 100 appear not to work?
xFilteredFull = [];
for subject = 101:109
    if (subject ~= 88) && (subject ~= 92)
        for sample = 1:240
            fprintf('Converting back subject: %d, sample: %d\n', subject, sample)
            xFilteredFull(subject, sample, :, :) = pinv(squeeze(Wfull(subject, sample, :, :)))' ...
                *squeeze(SfullRemoved(subject, sample, :, :));
        end
    end
end

%% Save samples
for subject = 1:109
    fileName = sprintf('Subject%dFilteredSamples.mat', subject);
    subjectData = squeeze(xFilteredFull(subject, :, :, :));
    save(fileName, 'subjectData');
end
