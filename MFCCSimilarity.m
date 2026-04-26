function [Data, DataMean, PercentSimilarity] = MFCCSimilarity(TutorPath, PupilPath, TutorName, filename_Tutor, Txtfilename_Tutor, MotifSyll_Tutor, PupilName, filename_Pupil, Txtfilename_Pupil, MotifSyll_Pupil)

%   -----------------------------------------------------------------------
%   Example input
%
% TutorPath = '/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/Temp/orange19black199/31072023/ASSLNoteFiles';
% PupilPath = '/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/Temp/blue114/FinalSong2/13022024/ASSLNoteFiles';
%
% TutorName = {'orange19black199'};
% filename_Tutor = '20SongFiles.txt.ASSLData.mat';
% Txtfilename_Tutor = 'AllBouts_2000.txt';
% MotifSyll_Tutor = 'abc';
%
% PupilName = {'blue114'};
% filename_Pupil = '20SongFiles.txt.ASSLData.mat';
% Txtfilename_Pupil = 'AllBouts_2000.txt';
% MotifSyll_Pupil = 'abc';


%   Written by
%   Anand C Krishnan
%   29.09.2025
%   -----------------------------------------------------------------------

totalSteps = 5; % Number of major steps
progressPerStep = 1 / totalSteps; % Portion of waitbar per step
f = waitbar(0, 'Starting');     %   creates a waitbar with message 'Starting', & progessbar at '0%'
set(f, 'Name', ['Bird name: ' PupilName{1}]); % Set the window title
pause(0.5)
Cn = 0;

%   Save file location
folderPath = '/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/Results';
%folderPath = '/run/media/hummingbird/AnandsSSD/TempLabPC/Results';


Data = {'Tutor', 'Pupil', 'Tutor file name', 'Pupil file name', 'Tutor bout', 'Tutor syll no', 'Tutor syll label', 'Pupil bout', 'Pupil syll no', 'Pupil syll label', 'crossCorr matrix', 'Similarity score SSIM', 'Similarity score SCC', 'Similarity score MFCC'};
NumCn = 2;
TutorBoutCn = 0;

AllTutorSyll = {};

cd (TutorPath)
load(filename_Tutor);
Onsets_Tutor = handles.ASSL.SyllOnsets;
Offsets_Tutor = handles.ASSL.SyllOffsets;
FileNames_Tutor = handles.ASSL.FileName;
AllLabels_Tutor = handles.ASSL.SyllLabels;
cd ..

Data_Tutor = importdata(Txtfilename_Tutor); % Used to get bout information present in the txt file.
BoutOnsets_Tutor = round(Data_Tutor.data(:,1)); % time is in msec
BoutOffsets_Tutor = round(Data_Tutor.data(:,2));% time is in msecs
BoutFiles_Tutor = Data_Tutor.textdata(2:end,1);
BoutOnsetIndices_Tutor = Data_Tutor.data(:,3);
BoutOffsetIndices_Tutor = Data_Tutor.data(:,4);

close(handles.SpikeSorterMainFig)


for i = 1:length(BoutFiles_Tutor)
    cd (TutorPath)
    cd ..
    Index_Tutor = find(ismember(FileNames_Tutor,BoutFiles_Tutor{i}));% Identify the file with name similar to the boutfile name
    SyllOnset_Tutor = Onsets_Tutor{Index_Tutor};
    SyllOffset_Tutor = Offsets_Tutor{Index_Tutor};
    Labels_Tutor = AllLabels_Tutor{Index_Tutor};
    BoutOnsetIndex_Tutor = BoutOnsetIndices_Tutor(i); %BoutOnsetIndex - Index of first syllable of a bout
    BoutOffsetIndex_Tutor = BoutOffsetIndices_Tutor(i);  %BoutOffsetIndex - Index of last syllable of a bout
    BoutLabels_Tutor = Labels_Tutor(BoutOnsetIndex_Tutor:BoutOffsetIndex_Tutor); % BoutLables - Labels of all syllables present in a bout
    BoutOnset_Tutor = SyllOnset_Tutor(BoutOnsetIndex_Tutor:BoutOffsetIndex_Tutor); % BoutOnset - Onsets of all syllables in a bout
    BoutOffset_Tutor = SyllOffset_Tutor(BoutOnsetIndex_Tutor:BoutOffsetIndex_Tutor); % BoutOffset - Offsets of all syllables in a bout

    if contains(BoutLabels_Tutor, MotifSyll_Tutor)
        TutorBoutCn = TutorBoutCn+1;
        if TutorBoutCn<11

            for j = 1:length(MotifSyll_Tutor)
                cd (TutorPath)
                cd ..
                TempMotifs_Tutor = strfind(BoutLabels_Tutor,MotifSyll_Tutor(j));
                TempSyllOnset_Tutor = BoutOnset_Tutor(TempMotifs_Tutor(1));
                TempSyllOffset_Tutor = BoutOffset_Tutor(TempMotifs_Tutor(1));
                [x1, fs1] = audioread(BoutFiles_Tutor{i}, [round((TempSyllOnset_Tutor/1000)*44100) round((TempSyllOffset_Tutor/1000)*44100)]);

                if i == 1
                    TutorSyl = x1;
                    AllTutorSyll{i, j} = num2cell(TutorSyl);
                end
                              

                %------------------------------   Pupil   ---------------------------------
                PupilBoutCn = 0;
                cd (PupilPath)
                load(filename_Pupil);
                Onsets_Pupil = handles.ASSL.SyllOnsets;
                Offsets_Pupil = handles.ASSL.SyllOffsets;
                FileNames_Pupil = handles.ASSL.FileName;
                AllLabels_Pupil = handles.ASSL.SyllLabels;
                cd ..

                Data_Pupil = importdata(Txtfilename_Pupil); % Used to get bout information present in the txt file.
                BoutOnsets_Pupil = round(Data_Pupil.data(:,1)); % time is in msec
                BoutOffsets_Pupil = round(Data_Pupil.data(:,2));% time is in msecs
                BoutFiles_Pupil = Data_Pupil.textdata(2:end,1);
                BoutOnsetIndices_Pupil = Data_Pupil.data(:,3);
                BoutOffsetIndices_Pupil = Data_Pupil.data(:,4);

                close(handles.SpikeSorterMainFig)
                

                for k = 1:length(BoutFiles_Pupil)
                    Index_Pupil = find(ismember(FileNames_Pupil,BoutFiles_Pupil{k}));% Identify the file with name similar to the boutfile name
                    SyllOnset_Pupil = Onsets_Pupil{Index_Pupil};
                    SyllOffset_Pupil = Offsets_Pupil{Index_Pupil};
                    Labels_Pupil = AllLabels_Pupil{Index_Pupil};
                    BoutOnsetIndex_Pupil = BoutOnsetIndices_Pupil(k); %BoutOnsetIndex - Index of first syllable of a bout
                    BoutOffsetIndex_Pupil = BoutOffsetIndices_Pupil(k);  %BoutOffsetIndex - Index of last syllable of a bout
                    BoutLabels_Pupil = Labels_Pupil(BoutOnsetIndex_Pupil:BoutOffsetIndex_Pupil); % BoutLables - Labels of all syllables present in a bout
                    BoutOnset_Pupil = SyllOnset_Pupil(BoutOnsetIndex_Pupil:BoutOffsetIndex_Pupil); % BoutOnset - Onsets of all syllables in a bout
                    BoutOffset_Pupil = SyllOffset_Pupil(BoutOnsetIndex_Pupil:BoutOffsetIndex_Pupil); % BoutOffset - Offsets of all syllables in a bout

                    if contains(BoutLabels_Pupil, MotifSyll_Pupil)
                        PupilBoutCn = PupilBoutCn+1;
                        if PupilBoutCn<11

                            for l = 1:length(MotifSyll_Pupil)
                                TempMotifs_Pupil = strfind(BoutLabels_Pupil,MotifSyll_Pupil(l));
                                TempSyllOnset_Pupil = BoutOnset_Pupil(TempMotifs_Pupil(1));
                                TempSyllOffset_Pupil = BoutOffset_Pupil(TempMotifs_Pupil(1));
                                [x2, fs2] = audioread(BoutFiles_Pupil{k}, [round((TempSyllOnset_Pupil/1000)*44100) round((TempSyllOffset_Pupil/1000)*44100)]);

                                if k == 1
                                    PupilSyl = x2;
                                    AllPupilSyll{k, l} = num2cell(PupilSyl);
                                end


                                % Ensure both signals have the same sampling rate
                                if fs1 ~= fs2
                                    error('Sampling rates of the two signals must match!');
                                end


                                %----------------------------   SpecCrossCorr   ---------------------------
                                %
                                %---------------------------------- START ---------------------------------

                                nfft=round(fs1*8/1000);
                                nfft = 2^nextpow2(nfft);
                                window = hanning(nfft);
                                noverlap = round(0.95*length(window)); %number of overlapping points

                                [S1, F1, T1] = spectrogram(x1, window, noverlap, nfft, fs1);
                                [S2, F2, T2] = spectrogram(x2, window, noverlap, nfft, fs2);

                                % Convert to magnitude or dB scale
                                %   A common formula used to convert a signal magnitude to decibels (dB) is :-
                                %       dB = 20 * log10​(magnitude)
                                S1_dB = 20*log10(abs(S1));
                                S2_dB = 20*log10(abs(S2));


                                %   Normalize spectrograms
                                S1_norm = (S1_dB - mean(S1_dB(:))) / std(S1_dB(:));
                                S2_norm = (S2_dB - mean(S2_dB(:))) / std(S2_dB(:));


                                %  Resize pupil spectrogram to match tutor
                                S2_norm = imresize(S2_norm, size(S1_norm));


                                % %   Resize spectrograms
                                % %   Cropping the spectrograms to the smallest common size
                                % minCols = min(size(S1_norm,2), size(S2_norm,2));
                                % S1_norm = S1_norm(:,1:minCols);
                                % S2_norm = S2_norm(:,1:minCols);


                                %   Similarity Scores   ----------------------------
                                %   START   ----------------------------------------
                                %
                                %   #1 SSIM
                                %   Compute SSIM between two matrices
                                [ssim_value, ssim_map] = ssim(S1_norm, S2_norm);
                                SimilarityScoreSSIM = ((ssim_value + 1) / 2) * 100;
                                %   SSIM value is between -1 and +1 is coverted to 0-100%


                                %   #2 SpecCrossCorr
                                %   2D cross-correlation
                                corrMatrix = xcorr2(S1_norm, S2_norm);

                                max_corr = max(corrMatrix(:));
                                similarity_score = max_corr / (norm(S1_norm, 'fro') * norm(S2_norm, 'fro'));
                                SimilarityScoreSCC = similarity_score*100;

                                
                                %   #3 Mel Frequency Cepstral Coefficients (MFCCs)
                                %   Calculate MFCCs
                                MFCCcoeffs1 = mfcc(x1, fs1);
                                MFCCcoeffs2 = mfcc(x2, fs2);

                                % Dynamic Time Warping
                                % Compute DTW distance and path
                                [distMFCC, ix, iy] = dtw(MFCCcoeffs1', MFCCcoeffs2');
                                normDistMFCC = distMFCC / length(ix);
                                similarityMFCC = (1 / (1 + normDistMFCC))*100;
                                SimilarityScoreMFCC = similarityMFCC;
                                %
                                %   END ------------------------------------------



                                Data{NumCn,1} = TutorName;
                                Data{NumCn,2} = PupilName;
                                Data{NumCn,3} = BoutFiles_Tutor{i};
                                Data{NumCn,4} = BoutFiles_Pupil{k};
                                Data{NumCn,5} = TutorBoutCn;
                                Data{NumCn,6} = j;
                                Data{NumCn,7} = MotifSyll_Tutor(j);
                                Data{NumCn,8} = PupilBoutCn;
                                Data{NumCn,9} = l;
                                Data{NumCn,10} = MotifSyll_Pupil(l);
                                Data{NumCn,11} = corrMatrix;
                                Data{NumCn,12} = SimilarityScoreSSIM;
                                Data{NumCn,13} = SimilarityScoreSCC;
                                Data{NumCn,14} = SimilarityScoreMFCC;
                                NumCn = NumCn+1;

                                %fprintf(['Tutor bout ' num2str(TutorBoutCn) ', tutor syll ' num2str(j) ', pupil bout ' num2str(PupilBoutCn) ', pupil syll ' num2str(l) ' done. \n']);

                                Cn = Cn+1;
                                waitbar(Cn/(10*length(MotifSyll_Tutor)*10*length(MotifSyll_Pupil))*progressPerStep, f, sprintf('Calculating similarity... %d %%', floor(Cn/(10*length(MotifSyll_Tutor)*10*length(MotifSyll_Pupil))*100)));

                            end
                        end
                    end
                end
            end
        end
    end
end


DataMean = {'Tutor', 'Pupil', 'Tutor syll no', 'Tutor syll label', 'Pupil syll no', 'Pupil syll label','Mean matrix', 'Mean similarity score SSIM', 'Std dev similarity score SSIM', '1 = Highest score (SSIM)', 'Mean similarity score SCC', 'Std dev similarity score SCC', '1 = Highest score (SCC)', 'Mean similarity score MFCC', 'Std dev similarity score MFCC', '1 = Highest score (MFCC)'};
NumCn = 2;
Cn = 0;

for j = 1:length(MotifSyll_Tutor)
    for l = 1:length(MotifSyll_Pupil)
        Idx = find(cell2mat(Data(2:end,6))==j & cell2mat(Data(2:end,9))==l);
        Idx = Idx+1;
        MeanSimilaritySSIM = mean(cell2mat((Data(Idx,12))));
        StdDevSimilaritySSIM = std(cell2mat((Data(Idx,12))));

        MeanSimilaritySCC = mean(cell2mat((Data(Idx,13))));
        StdDevSimilaritySCC = std(cell2mat((Data(Idx,13))));

        MeanSimilarityMFCC = mean(cell2mat((Data(Idx,14))));
        StdDevSimilarityMFCC = std(cell2mat((Data(Idx,14))));

        %   ---------------------------------------------------------------
        M = (Data(Idx,11));

        % Find max number of rows and columns
        maxRows = max(cellfun(@(x) size(x,1), M));
        maxCols = max(cellfun(@(x) size(x,2), M));
        %   @(x) size(x,1) = an anonymous function that takes an input x (a matrix) and returns the number of rows in x.
        %   size(x,1) = "get the size of dimension 1 of x", which is the number of rows
        %   The function cellfun applies the anonymous function to each cell of the cell array M.
        %   So it returns a numeric array containing the number of rows of every matrix stored inside M.

        % Pad matrices with NaN to max size
        padWithNaN = @(mat) padarray(mat, [maxRows - size(mat,1), maxCols - size(mat,2)], NaN, 'post');
        % padWithNaN = @(mat) defines an anonymous function named padWithNaN that takes one input argument mat (a matrix).
        % padarray(mat, [a, b], NaN, 'post')
            % This function pads the matrix mat by adding extra elements around it.
            % mat: the original matrix to be padded.
            % [a, b]: a two-element vector specifying how many rows and columns to add.
            % a = number of rows to add
            % b = number of columns to add
            % NaN: the value used to fill the padded elements (here, NaN — "Not a Number").
            % 'post': indicates padding is added after the existing data (at the bottom and right sides).
            % Calculating how much to pad:
            % maxRows - size(mat,1) computes how many rows to add to mat to reach the maximum row size (maxRows).
            % maxCols - size(mat,2) computes how many columns to add to mat to reach the maximum column size (maxCols).


        M_padded = cellfun(padWithNaN, M, 'UniformOutput', false);

        % Stack into 3D matrix
        stacked = cat(3, M_padded{:});

        % Calculate mean ignoring NaN padding
        meanMatrix = mean(stacked, 3, 'omitnan');
        %   ---------------------------------------------------------------


        DataMean{NumCn,1} = TutorName;
        DataMean{NumCn,2} = PupilName;
        DataMean{NumCn,3} = j;
        DataMean{NumCn,4} = MotifSyll_Tutor(j);
        DataMean{NumCn,5} = l;
        DataMean{NumCn,6} = MotifSyll_Pupil(l);
        DataMean{NumCn,7} = meanMatrix;
        DataMean{NumCn,8} = MeanSimilaritySSIM;
        DataMean{NumCn,9} = StdDevSimilaritySSIM;
        DataMean{NumCn,11} = MeanSimilaritySCC;
        DataMean{NumCn,12} = StdDevSimilaritySCC;
        DataMean{NumCn,14} = MeanSimilarityMFCC;
        DataMean{NumCn,15} = StdDevSimilarityMFCC;
        NumCn = NumCn+1;

        Cn = Cn+1;
        pause(0.5)
        waitbar(progressPerStep + (Cn/(length(MotifSyll_Tutor)*length(MotifSyll_Pupil)))*progressPerStep, f, sprintf('Calculating mean... %d %%', round((Cn/(length(MotifSyll_Tutor)*length(MotifSyll_Pupil)))*100)));

    end
end

MaxSim_SSIM = [];
MaxSim_SCC = [];
MaxSim_MFCC = [];

for j = 1:length(MotifSyll_Tutor)
    Idx = find(cell2mat(DataMean(2:end,3))==j);
    Idx = Idx+1;
    MaxSimSSIM = max(cell2mat(DataMean(Idx,8)));
    MaxSimSCC = max(cell2mat(DataMean(Idx,11)));
    MaxSimMFCC = max(cell2mat(DataMean(Idx,14)));

    MaxSim_SSIM = [MaxSim_SSIM, MaxSimSSIM];
    MaxSim_SCC = [MaxSim_SCC, MaxSimSCC];
    MaxSim_MFCC = [MaxSim_MFCC, MaxSimMFCC];

    % Score: 1 for max, 0 for others
    scoreSSIM = double(cell2mat(DataMean(Idx,8)) == MaxSimSSIM);
    scoreSCC = double(cell2mat(DataMean(Idx,11)) == MaxSimSCC);
    scoreMFCC = double(cell2mat(DataMean(Idx,14)) == MaxSimMFCC);

    for m = 1:length(Idx)
        DataMean{Idx(m),10} = scoreSSIM(m);
        DataMean{Idx(m),13} = scoreSCC(m);
        DataMean{Idx(m),16} = scoreMFCC(m);
    end
    
    pause(0.5)
    waitbar(2*progressPerStep + (j/length(MotifSyll_Tutor))*progressPerStep, f, sprintf('Scoring... %d %%', round((j/length(MotifSyll_Tutor))*100)));

end

%------------------------   Percentage similarity  ------------------------

PercentSimilarity = {'Pupil name', 'Tutor name', 'SSIM', 'SCC', 'MFCC'};
PercentSimilarity{2,1} = PupilName;
PercentSimilarity{2,2} = TutorName;
PercentSimilarity{2,3} = mean(MaxSim_SSIM);
PercentSimilarity{2,4} = mean(MaxSim_SCC);
PercentSimilarity{2,5} = mean(MaxSim_MFCC);

pause(0.5)
waitbar(3*progressPerStep, f, sprintf('Saving data... %d%%', 0));

%save(fullfile(folderPath, [PupilName{1} '_Data']), 'Data', '-v7.3');
save(fullfile(folderPath, [PupilName{1} '_DataMean']), 'DataMean');
save(fullfile(folderPath, [PupilName{1} '_PercentSimilarity']), 'PercentSimilarity');

waitbar(3*progressPerStep + progressPerStep, f, sprintf('Saving data... %d%%', 100));
pause(0.5)




%--------------------------------   Figure  -------------------------------

SimilarityValues = {'SSIM', 'SCC', 'MFCC'};
Column = [8 11 14];


for n = 1:length(SimilarityValues)
    M = cell2mat(DataMean(2:end,Column(n)));
    N = cell2mat(DataMean(2:end,Column(n)+2));
    rows = length(MotifSyll_Pupil);
    cols = length(MotifSyll_Tutor);
    HeatMatrix = reshape(M, rows, cols);
    ScoreMatrix = reshape(N, rows, cols);

    Rows = length(MotifSyll_Pupil)+1;
    Cols = length(MotifSyll_Tutor)+1;
    Matrix = reshape(1:(Rows*Cols), Cols, Rows).';
    Location = Matrix(1:end-1, 2:end);
    Location = reshape(Location.', 1, []);

    subplot(Rows, Cols, Location)
    h = heatmap(HeatMatrix, 'Colormap', copper);
    % h.XDisplayLabels = MotifSyll_Tutor(:);
    % h.YDisplayLabels = MotifSyll_Pupil(:);
    h.XDisplayLabels = repmat({''}, size(h.XDisplayData));
    h.YDisplayLabels = repmat({''}, size(h.YDisplayData));
    xlabel([TutorName{1} ' (' MotifSyll_Tutor ')']);
    ylabel([PupilName{1}  ' (' MotifSyll_Pupil ')']);
    colorbar off
    title([PupilName{1} ' similarity matrix (' SimilarityValues{n} ')'])
    set(gca,'FontSize',15,'Fontname','Arial')


    nfft=round(fs1*8/1000);
    nfft = 2^nextpow2(nfft);
    window = hanning(nfft);
    noverlap = round(0.95*length(window)); %number of overlapping points
    ScaleBarTime = 50;
    ScaleBarFreq = 5;

    for j = 1:length(MotifSyll_Tutor)
        subplot(Rows, Cols, Rows*Cols-Cols+j+1)
        spectrogram(cell2mat(AllTutorSyll{1,j}), window, noverlap, nfft, fs1, 'yaxis')
        hold on;
        ax = gca;                  % Get current axes
        ax.XTick = [];
        ax.YTick = [];
        ax.XTickLabel = [];
        ax.YTickLabel = [];
        ax.XLabel.String = '';
        ax.YLabel.String = '';
        ax.XColor = 'none';  % Hide x-axis line
        ax.YColor = 'none';  % Hide y-axis line
        colorbar off
        a = axis;
        plot([a(1) a(1)+ScaleBarTime],[a(3) a(3)],'-k','linewidth',2) %   50ms
        plot([a(1) a(1)],[a(3) a(3)+ScaleBarFreq],'-k','linewidth',2)  %   5kHz

        title(MotifSyll_Tutor(j))
        set(gca,'FontSize',15,'Fontname','Arial')
    end

    for l = 1:length(MotifSyll_Pupil)
        subplot(Rows, Cols, Cols*l-Cols+1)
        spectrogram(cell2mat(AllPupilSyll{1,l}), window, noverlap, nfft, fs1, 'yaxis')

        hold on;
        ax = gca;                  % Get current axes
        ax.XTick = [];
        ax.YTick = [];
        ax.XTickLabel = [];
        ax.YTickLabel = [];
        ax.XLabel.String = '';
        ax.YLabel.String = '';
        ax.XColor = 'none';  % Hide x-axis line
        ax.YColor = 'none';  % Hide y-axis line
        colorbar off
        a = axis;
        plot([a(1) a(1)+ScaleBarTime],[a(3) a(3)],'-k','linewidth',2) %   50ms
        plot([a(1) a(1)],[a(3) a(3)+ScaleBarFreq],'-k','linewidth',2)  %   5kHz

        title(MotifSyll_Pupil(l))
        set(gca,'FontSize',15,'Fontname','Arial')
    end

    subplot(Rows, Cols, Rows*Cols-Cols+1)
    h = heatmap(ScoreMatrix, 'Colormap', copper);
    h.XDisplayLabels = MotifSyll_Tutor(:);
    h.YDisplayLabels = MotifSyll_Pupil(:);
    colorbar off
    title('Score matrix')
    set(gca,'FontSize',15,'Fontname','Arial')

    % Add common text at the bottom of the figure
    annotation('textbox', [0.1 0.02 0.8 0.05], 'String', ['Spectrogram: X axis = Time (scale bar = ',  num2str(ScaleBarTime), ' ms), Y axis = Frequency (scale bar = ' num2str(ScaleBarFreq) ' kHz)'], ...
        'EdgeColor', 'none', 'HorizontalAlignment', 'right','Fontname','Arial', 'FontSize', 12, 'FontWeight', 'normal');
    set(gcf,'Color','White')

    saveas(gcf, fullfile(folderPath,[PupilName{1} '_' SimilarityValues{n}]))
    close(gcf);

    waitbar(4*progressPerStep + (n/length(SimilarityValues))*progressPerStep, f, ['Graphing and saving... ' num2str(n) '/' num2str(length(SimilarityValues)) ' done']);
    pause(0.5)
end


waitbar(1,f,'Finishing');   %   updates the length of waitbar to 100% and display 'Finishing'
pause(0.5)      %      pause for 0.5 sec before continuing
close(f)