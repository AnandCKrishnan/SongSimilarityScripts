%   SpectrographicCrossCorr

Sheet1 = readtable('/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/AllBirdData.xlsx', 'Sheet', 1);
PupilName_1 = Sheet1.BirdName(1:24);
TutorName_1 = Sheet1.Tutor(1:24);
LMANRemaining = str2double(Sheet1.x_LMANRemaining_control_(1:24));
[LMANRemainingSorted, indices] = sort(LMANRemaining)

SpectrographicCrossCorrMatrices = {};

f = waitbar(0, 'Starting');     %   creates a waitbar with message 'Starting', & progessbar at '0%'
pause(0.5) 

for k = 2:length(PupilName_1)
    PupilPath = strcat('/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/SAP2011_New/Pupil_120/', PupilName_1(indices(k)), '/Motifs/Selected');
    TutorPath = strcat('/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/SAP2011_New/Tutor/', TutorName_1(indices(k)), '/Motifs/Selected');

    corrMatrixSum = [];
    for i = 1:10
        cd(TutorPath{1})
        TutorFiles = dir('*.wav');
        [x1, fs] = audioread(TutorFiles(i).name);

        for j = 1:10
            cd(PupilPath{1})
            PupilFiles = dir('*.wav');
            [x2, fs] = audioread(PupilFiles(j).name);

            window = hamming(256); %    A Hamming window of size 256 for STFT (Short-Time Fourier Transform)
            nfft = 512; %   FFT size — higher values give better frequency resolution
            noverlap = 200; %   Overlap between windows, here 200 samples

            [S1, F1, T1] = spectrogram(x1, window, noverlap, nfft, fs);
            [S2, F2, T2] = spectrogram(x2, window, noverlap, nfft, fs);

            % Convert to magnitude or dB scale
            S1_dB = 20*log10(abs(S1));
            S2_dB = 20*log10(abs(S2));


            %   Normalize spectrograms
            S1_norm = (S1_dB - mean(S1_dB(:))) / std(S1_dB(:));
            S2_norm = (S2_dB - mean(S2_dB(:))) / std(S2_dB(:));


            %   2D cross-correlation
            corrMatrix = xcorr2(S1_norm, S2_norm);
            
            if i==1 && j==1
                Size = size(corrMatrix);
            end

            Resize_corrMatrix = paddata(corrMatrix, [Size(1) Size(2)+100]);

            if i == 1
                corrMatrixSum = Resize_corrMatrix;
            else
                corrMatrixSum = [corrMatrixSum+Resize_corrMatrix];
            end
        end
    end
    
    SpectrographicCrossCorrMatrices{1, k} = PupilName_1(indices(k));
    SpectrographicCrossCorrMatrices{2, k} = [num2str(round(LMANRemaining(indices(k)), 2)) '%'];
    SpectrographicCrossCorrMatrices{3, k} = corrMatrixSum;

    subplot(4,6,k)
    imagesc(corrMatrixSum/100);
    caxis([-30000 70000])
    title(PupilName_1(indices(k)))
    subtitle([num2str(round(LMANRemaining(indices(k)), 2)) '%'])

    waitbar(k/length(PupilName_1), f, sprintf('Progress: %d %%', floor((k/length(PupilName_1))*100)));

end


h = axes(figure(1),'visible','off'); 
h.Title.Visible = 'on';
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
ylabel(h,'Frequency','FontWeight','bold');
xlabel(h,'Time','FontWeight','bold');
title(h,'Spectrographic Cross Correlation');
colorbar

set(gcf,'Color','White')
set(gca,'FontSize',15,'Fontname','Arial')
box off

