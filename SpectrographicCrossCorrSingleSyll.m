% SpectrographicCrossCorrSingleSyll


TutorPath = '/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/Temp/black120/17112022/ASSLNoteFiles';
PupilPath = '/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/Temp/pink164/FinalSong2/17022024/ASSLNoteFiles';

TutorName = {'black120'};
filename_Tutor = '20SongFiles.txt.ASSLData.mat';
Txtfilename_Tutor = 'AllBouts_2000.txt';
MotifSyll_Tutor = 'cba';

PupilName = {'pink164'};
filename_Pupil = '20SongFiles.txt.ASSLData.mat';
Txtfilename_Pupil = 'AllBouts_2000.txt';
MotifSyll_Pupil = 'bAd';



TutorPath = '/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/Temp/orange19black199/31072023/ASSLNoteFiles';
PupilPath = '/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/Temp/blue114/FinalSong2/13022024/ASSLNoteFiles';

TutorName = {'orange19black199'};
filename_Tutor = '20SongFiles.txt.ASSLData.mat';
Txtfilename_Tutor = 'AllBouts_2000.txt';
MotifSyll_Tutor = 'abc';

PupilName = {'blue114'};
filename_Pupil = '20SongFiles.txt.ASSLData.mat';
Txtfilename_Pupil = 'AllBouts_2000.txt';
MotifSyll_Pupil = 'abc';


TutorPath = '/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/Temp/orange19black199/31072023/ASSLNoteFiles';
PupilPath = TutorPath;
TutorName = {'orange19black199'};
filename_Tutor = '20SongFiles.txt.ASSLData.mat';
Txtfilename_Tutor = 'AllBouts_2000.txt';
MotifSyll_Tutor = 'abc';


TutorPath = '/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/Temp/green107white111/25082023/ASSLNoteFiles';
PupilPath = TutorPath;
TutorName = {'green107white111'};
filename_Tutor = '20SongFiles.txt.ASSLData.mat';
Txtfilename_Tutor = 'AllBouts_2000.txt';
MotifSyll_Tutor = 'abcdef';

PupilName = TutorName;
filename_Pupil = filename_Tutor;
Txtfilename_Pupil = Txtfilename_Tutor;
MotifSyll_Pupil = MotifSyll_Tutor;



f = waitbar(0, 'Starting');     %   creates a waitbar with message 'Starting', & progessbar at '0%'
pause(0.5)
Cn = 0;

Data = {'Tutor', 'Pupil', 'Tutor file name', 'Pupil file name', 'Tutor bout', 'Tutor syll no', 'Tutor syll label', 'Pupil bout', 'Pupil syll no', 'Pupil syll label', 'Similarity score', 'crossCorr matrix'};
NumCn = 2;
TutorBoutCn = 0;

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

                                % Ensure both signals have the same sampling rate
                                if fs1 ~= fs2
                                    error('Sampling rates of the two signals must match!');
                                end

                                amp1 = abs(x1);
                                logamp1 = log10(amp1+eps);

                                amp2 = abs(x2);
                                logamp2 = log10(amp2+eps);

                                MinRows = min(size(logamp1,1), size(logamp2,1));
                                logamp1 = logamp1(1:MinRows)
                                logamp2 = logamp2(1:MinRows)
                                corr(logamp1, logamp2)


                                %   #3 Mel Frequency Cepstral Coefficients (MFCCs)
                                %   Calculate MFCCs
                                MFCCcoeffs1 = mfcc(x1, fs1);
                                MFCCcoeffs2 = mfcc(x2, fs2);

                                % Dynamic Time Warping
                                % Compute DTW distance and path
                                [distMFCC, ix, iy] = dtw(MFCCcoeffs1', MFCCcoeffs2');
                                %normDistMFCC = distMFCC / length(ix);


                                % % % Apply a sharpened similarity function
                                % % % You can tweak 'alpha' for stronger contrast
                                % alpha = 0.5;  % Try 5, 10, 20, etc.
                                % 
                                % similarity = exp(-alpha * normDistMFCC);  % Will map large dist → near 0, small → near 1
                                % similarity_percent = similarity * 100;
                                %SimilarityScore = 


                                % %---------------------------------- START ---------------------------------
                                % nfft=round(fs1*8/1000);
                                % nfft = 2^nextpow2(nfft);
                                % window = hanning(nfft);
                                % noverlap = round(0.95*length(window)); %number of overlapping points
                                % 
                                % % Normalize
                                % x1 = x1 / max(abs(x1));
                                % x2 = x2 / max(abs(x2));
                                % 
                                % [S1, F1, T1] = spectrogram(x1, window, noverlap, nfft, fs1);
                                % [S2, F2, T2] = spectrogram(x2, window, noverlap, nfft, fs2);
                                % 
                                % % Take magnitude (ignore phase)
                                % S1_mag = abs(S1);
                                % S2_mag = abs(S2);
                                % 
                                % 
                                % % Normalize spectrograms
                                % S1_mag = S1_mag / max(S1_mag(:));
                                % S2_mag = S2_mag / max(S2_mag(:));
                                % 
                                % % Resize pupil spectrogram to match tutor
                                % S2_mag = imresize(S2_mag, size(S1_mag));
                                % 
                                % 
                                % % Compute DTW
                                % [dist, ix, iy] = dtw(S1_mag', S2_mag');  % Transpose so that time is along rows
                                % 
                                % % dist is DTW or other distance
                                % % Normalize it
                                % norm_dist = dist / max_dist;   % between 0 and 1
                                % 
                                % 
                                % % Normalize by path length
                                % max_dist = sqrt(size(S1_mag,1)^2 + size(S1_mag,2)^2);
                                % similarity = (1 - (dist / max_dist))*100;  % Value between 0 and 100
                                % SimilarityScore = similarity;
                                % %-------------------------------- END ----------------------------------
                                % 


                                % %----------------------------   SpecCrossCorr   ---------------------------
                                % %
                                % %---------------------------------- START ---------------------------------
                                % 
                                % nfft=round(fs1*8/1000);
                                % nfft = 2^nextpow2(nfft);
                                % window = hanning(nfft);
                                % noverlap = round(0.95*length(window)); %number of overlapping points
                                % 
                                % [S1, F1, T1] = spectrogram(x1, window, noverlap, nfft, fs1);
                                % [S2, F2, T2] = spectrogram(x2, window, noverlap, nfft, fs2);
                                % 
                                % % Convert to magnitude or dB scale
                                % %   A common formula used to convert a signal magnitude to decibels (dB) is :-
                                % %       dB = 20 * log10​(magnitude)
                                % S1_dB = 20*log10(abs(S1));
                                % S2_dB = 20*log10(abs(S2));
                                % 
                                % 
                                % %   Normalize spectrograms
                                % S1_norm = (S1_dB - mean(S1_dB(:))) / std(S1_dB(:));
                                % S2_norm = (S2_dB - mean(S2_dB(:))) / std(S2_dB(:));
                                % 
                                % 
                                % %   Resize pupil spectrogram to match tutor
                                % %S2_norm = imresize(S2_norm, size(S1_norm));
                                % 
                                % 
                                % %   Resize spectrograms
                                % %   Cropping the spectrograms to the smallest common size
                                % minCols = min(size(S1_norm,2), size(S2_norm,2));
                                % S1_norm = S1_norm(:,1:minCols);
                                % S2_norm = S2_norm(:,1:minCols);
                                % 
                                % 
                                % %   2D cross-correlation
                                % corrMatrix = xcorr2(S1_norm, S2_norm);
                                % 
                                % %-------------------------------- END ----------------------------------

                               

                                %--------------------------   Similarity Score   --------------------------
                                %
                                % %------------------------------   Features   ----------------------------
                                % %
                                % %--------------------------------- START --------------------------------
                                % 
                                % % Mel Frequency Cepstral Coefficients (MFCCs)
                                % % Calculate MFCCs
                                % MFCCcoeffs1 = mfcc(x1, fs1);
                                % MFCCcoeffs2 = mfcc(x2, fs2);
                                % 
                                % 
                                % % Dynamic Time Warping
                                % % Compute DTW distance and path
                                % [distMFCC, ix, iy] = dtw(MFCCcoeffs1', MFCCcoeffs2');
                                % normDistMFCC = distMFCC / length(ix);
                                % similarityMFCC = (1 / (1 + normDistMFCC))*100;
                                % 
                                % SimilarityScore = similarityMFCC;
                                % 
                                % %-------------------------------- END ----------------------------------


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
                                %Data{NumCn,11} = SimilarityScore;
                                %Data{NumCn,12} = corrMatrix;
                                Data{NumCn,11} = distMFCC;
                                NumCn = NumCn+1;

                                fprintf(['Tutor bout ' num2str(TutorBoutCn) ', tutor syll ' num2str(j) ', pupil bout ' num2str(PupilBoutCn) ', pupil syll ' num2str(l) ' done. \n']);

                                Cn = Cn+1;
                                waitbar(Cn/(10*length(MotifSyll_Tutor)*10*length(MotifSyll_Pupil)), f, sprintf('Progress: %d %%', floor(Cn/(10*length(MotifSyll_Tutor)*10*length(MotifSyll_Pupil))*100)));

                            end
                        end
                    end
                end
            end
        end
    end
end

waitbar(1,f,'Finishing');   %   updates the length of waitbar to 100% and display 'Finishing'
pause(0.5)      %      pause for 0.5 sec before continuing
close(f)
    
%minDist = min(cell2mat(Data(2:end,13)));  % from same-syllable pairs
%maxDist = max(cell2mat(Data(2:end,13)));  % from different-syllable pairs

minDist = 0;
maxDist = 200;


for m = 1:length(Data(2:end,13))
    actualDist = cell2mat(Data(m+1,13));
    similarity = 1 - (actualDist - minDist) / (maxDist - minDist);
    SimilarityPercent = similarity*100;
    Data{m+1,11} = SimilarityPercent;
end



DataMean = {'Tutor', 'Pupil', 'Tutor syll no', 'Tutor syll label', 'Pupil syll no', 'Pupil syll label', 'Mean similarity score', 'Std dev similarity score', '1 = Highest score'};
NumCn = 2;

for j = 1:length(MotifSyll_Tutor)
    for l = 1:length(MotifSyll_Pupil)
        Idx = find(cell2mat(Data(2:end,6))==j & cell2mat(Data(2:end,9))==l);
        Idx = Idx+1;
        MeanSimilarity = mean(cell2mat((Data(Idx,11))));
        StdDevSimilarity = std(cell2mat((Data(Idx,11))));


        % M = (Data(Idx,12));
        % 
        % % Find max number of rows and columns
        % maxRows = max(cellfun(@(x) size(x,1), M));
        % maxCols = max(cellfun(@(x) size(x,2), M));
        % %   @(x) size(x,1) = an anonymous function that takes an input x (a matrix) and returns the number of rows in x.
        % %   size(x,1) = "get the size of dimension 1 of x", which is the number of rows
        % %   The function cellfun applies the anonymous function to each cell of the cell array M. 
        % %   So it returns a numeric array containing the number of rows of every matrix stored inside M.
        % 
        % % Pad matrices with NaN to max size
        % padWithNaN = @(mat) padarray(mat, [maxRows - size(mat,1), maxCols - size(mat,2)], NaN, 'post');
        % % padWithNaN = @(mat) defines an anonymous function named padWithNaN that takes one input argument mat (a matrix).
        % % padarray(mat, [a, b], NaN, 'post')
        %     % This function pads the matrix mat by adding extra elements around it.
        %     % mat: the original matrix to be padded.
        %     % [a, b]: a two-element vector specifying how many rows and columns to add.
        %     % a = number of rows to add
        %     % b = number of columns to add
        %     % NaN: the value used to fill the padded elements (here, NaN — "Not a Number").
        %     % 'post': indicates padding is added after the existing data (at the bottom and right sides).
        %     % Calculating how much to pad:
        %     % maxRows - size(mat,1) computes how many rows to add to mat to reach the maximum row size (maxRows).
        %     % maxCols - size(mat,2) computes how many columns to add to mat to reach the maximum column size (maxCols).
        % 
        % 
        % M_padded = cellfun(padWithNaN, M, 'UniformOutput', false);
        % 
        % % Stack into 3D matrix
        % stacked = cat(3, M_padded{:});
        % 
        % % Calculate mean ignoring NaN padding
        % meanMatrix = mean(stacked, 3, 'omitnan');


        DataMean{NumCn,1} = TutorName;
        DataMean{NumCn,2} = PupilName;
        DataMean{NumCn,3} = j;
        DataMean{NumCn,4} = MotifSyll_Tutor(j);
        DataMean{NumCn,5} = l;
        DataMean{NumCn,6} = MotifSyll_Pupil(l);
        DataMean{NumCn,7} = MeanSimilarity;
        DataMean{NumCn,8} = StdDevSimilarity;
        %DataMean{NumCn,8} = meanMatrix;
        NumCn = NumCn+1;  
    end
end


for j = 1:length(MotifSyll_Tutor)
    Idx = find(cell2mat(DataMean(2:end,3))==j);
    Idx = Idx+1;
    MaxSim = max(cell2mat(DataMean(Idx,7)));

    % Score: 1 for max, 0 for others
    score = double(cell2mat(DataMean(Idx,7)) == MaxSim);

    for m = 1:length(Idx)
        DataMean{Idx(m),9} = score(m);
    end
end


M = cell2mat(DataMean(2:end,7));

rows = length(MotifSyll_Pupil);
cols = length(MotifSyll_Tutor);
HeatMatrix = reshape(M, rows, cols);
h = heatmap(HeatMatrix, 'Colormap', copper);

h.XDisplayLabels = MotifSyll_Tutor(:);
h.YDisplayLabels = MotifSyll_Pupil(:);
xlabel([TutorName ' (' MotifSyll_Tutor ')']);
ylabel([PupilName  ' (' MotifSyll_Pupil ')']);
set(gcf,'Color','White')
set(gca,'FontSize',15,'Fontname','Arial')


folderPath = '/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/Results';
save(fullfile(folderPath, [PupilName '_Data']), 'Data');
save(fullfile(folderPath, [PupilName '_DataMean']), 'DataMean');
saveas(gcf, fullfile(folderPath,[PupilName '_Heatmap']))
close(gcf);



% numerator = max(corrMatrix(:));
% denominator = sqrt(sum(S1_norm(:).^2) * sum(S2_norm(:).^2));
% SimilarityScore = numerator/denominator;
% eval([['Idx_' num2str(j) '_' num2str(l)] '= Idx'])


% NumCn = 1;
% for k = 2:length(DataMean)
%     subplot(3,3,NumCn)
%     imagesc(DataMean{k,8})
%     %caxis([-5000 15000])
%     title([DataMean{k,4} '_' DataMean{k,6}])
% 
%     NumCn = NumCn+1;
% end
% 
% 
% h = axes(figure(1),'visible','off'); 
% h.Title.Visible = 'on';
% h.XLabel.Visible = 'on';
% h.YLabel.Visible = 'on';
% ylabel(h,'Log(frequency)','FontWeight','bold');
% xlabel(h,'Log(time)','FontWeight','bold');
% title(h,'Spectrographic Cross Correlation');
% colorbar
% 
% set(gcf,'Color','White')
% set(gca,'FontSize',15,'Fontname','Arial')
% box off
