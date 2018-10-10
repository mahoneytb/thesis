% % Detect artefacts and remove
% artefactsRemoved = [];
% for subject = 93:109
%     if subject ~= 88
%         for sample = 1:240
%             fprintf('Subject: %d Sample: %d\n', subject, sample);
%             for c = 1:15
%                 W = squeeze(Wfull(subject, sample, :, c));
%                 S = squeeze(Sfull(subject, sample, c, :));
%                 features = getFeatures(W, S);
%                 y = bestNet(features);
%                 if y(2) > y(1)
%                     SfullRemoved(subject, sample, c, :) = 0;
%                     count = count + 1;
%                 end
%             end
%             fprintf('Removed %d artefacts\n', count)
%             artefactsRemoved = [artefactsRemoved, count];
%             count = 0;
%         end
%     end
% end

%%

% for sub = 1:109
%     for samp = 1:100
%         x = pinv(squeeze(Wfull(sub, samp, :, :)))'*squeeze(Sfull(sub, samp, :, :));
%         xfilt = pinv(squeeze(Wfull(sub, samp, :, :)))'*squeeze(SfullRemoved(sub, samp, :, :));
% 
%         for i = 1:30
%             figure()
%             hold on
%             plot(x(i,:), 'r')
%             plot(xfilt(i,:), 'b')
%         end
%     end
% end

%% Convert S and W back to x
% subjects 88, 92 and 100 appear not to work?
xFiltered = [];
for subject = 1:20
    if (subject ~= 88) && (subject ~= 92) && (subject ~= 100)
        % 0.5 sec samples over 2 min
        % each sample contains previous 2 secs of data (320 samples)
        for sample = 1:240
            fprintf('Converting back subject: %d, sample: %d\n', subject, sample)
            xFiltered(sample, :, :) = pinv(squeeze(Wfull(subject, sample, :, :)))' ...
                *squeeze(SfullRemoved(subject, sample, :, :));
        end
        fileName = sprintf('SubjectTest%dFilteredSamples.mat', subject);
        subjectData = squeeze(xFiltered);
        save(fileName, 'subjectData');
        xFiltered = [];
    end
end
