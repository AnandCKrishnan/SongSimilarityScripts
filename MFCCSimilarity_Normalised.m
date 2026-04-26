function [Data, DataMean, PercentSimilarity] = MFCCSimilarity_Normalised(TutorPath, PupilPath, TutorName, filename_Tutor, Txtfilename_Tutor, MotifSyll_Tutor, PupilName, filename_Pupil, Txtfilename_Pupil, MotifSyll_Pupil)

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
%   12.10.2025
%   -----------------------------------------------------------------------



totalSteps = 3; % Number of major steps
progressPerStep = 1 / totalSteps; % Portion of waitbar per step
f = waitbar(0, 'Starting');     %   creates a waitbar with message 'Starting', & progessbar at '0%'
set(f, 'Name', ['Bird name: ' PupilName{1}]); % Set the window title
pause(0.5)
Cn = 0;

%   Save file location
%folderPath = '/Users/anandckrishnan/Documents/Anand/MSThesis/DataAnalysis/CrossCheck/SpectrographicCrossCorr/Results';
folderPath = '/run/media/hummingbird/AnandsSSD/TempLabPC/Results';



%   -----------------------------------------------------------------------
%   Tutor - Tutor
%   -----------------------------------------------------------------------

TutorData = {'Tutor', 'Tutor file name 1', 'Tutor file name 2', 'Tutor bout 1', 'Tutor syll no 1', 'Tutor syll label 1', 'Tutor bout 2', 'Tutor syll no 2', 'Tutor syll label 2', 'Distance'};
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

waitbar(0*progressPerStep, f, sprintf(['Calculating tutor syllable variability (1/', num2str(totalSteps), '): %d%%'], 0));

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

                if size(x1, 1) < round(fs1*0.03)
                    % Open the file for writing (if it doesn't exist, it will be created)
                    fileID = fopen([folderPath '/' PupilName{1} '_Error.txt'], 'a');
                    fprintf(fileID, ['Tutor: ' TutorName{1} ', File: '  BoutFiles_Tutor{i} ', Syllable: ' MotifSyll_Tutor(j) ', Duration too short - SKIPPED \n']);
                    fclose(fileID);
                end

                if size(x1, 1) >= round(fs1*0.03)

                    %------------------------------   Pupil   ---------------------------------
                    TutorBoutCn2 = 0;
                    cd (TutorPath)
                    load(filename_Tutor);
                    Onsets_Tutor2 = handles.ASSL.SyllOnsets;
                    Offsets_Tutor2 = handles.ASSL.SyllOffsets;
                    FileNames_Tutor2 = handles.ASSL.FileName;
                    AllLabels_Tutor2 = handles.ASSL.SyllLabels;
                    cd ..

                    Data_Tutor2 = importdata(Txtfilename_Tutor); % Used to get bout information present in the txt file.
                    BoutOnsets_Tutor2 = round(Data_Tutor2.data(:,1)); % time is in msec
                    BoutOffsets_Tutor2 = round(Data_Tutor2.data(:,2));% time is in msecs
                    BoutFiles_Tutor2 = Data_Tutor2.textdata(2:end,1);
                    BoutOnsetIndices_Tutor2 = Data_Tutor2.data(:,3);
                    BoutOffsetIndices_Tutor2 = Data_Tutor2.data(:,4);

                    close(handles.SpikeSorterMainFig)


                    for k = 1:length(BoutFiles_Tutor2)
                        Index_Tutor2 = find(ismember(FileNames_Tutor2,BoutFiles_Tutor2{k}));% Identify the file with name similar to the boutfile name
                        SyllOnset_Tutor2 = Onsets_Tutor2{Index_Tutor2};
                        SyllOffset_Tutor2 = Offsets_Tutor2{Index_Tutor2};
                        Labels_Tutor2 = AllLabels_Tutor2{Index_Tutor2};
                        BoutOnsetIndex_Tutor2 = BoutOnsetIndices_Tutor2(k); %BoutOnsetIndex - Index of first syllable of a bout
                        BoutOffsetIndex_Tutor2 = BoutOffsetIndices_Tutor2(k);  %BoutOffsetIndex - Index of last syllable of a bout
                        BoutLabels_Tutor2 = Labels_Tutor2(BoutOnsetIndex_Tutor2:BoutOffsetIndex_Tutor2); % BoutLables - Labels of all syllables present in a bout
                        BoutOnset_Tutor2 = SyllOnset_Tutor2(BoutOnsetIndex_Tutor2:BoutOffsetIndex_Tutor2); % BoutOnset - Onsets of all syllables in a bout
                        BoutOffset_Tutor2 = SyllOffset_Tutor2(BoutOnsetIndex_Tutor2:BoutOffsetIndex_Tutor2); % BoutOffset - Offsets of all syllables in a bout

                        if contains(BoutLabels_Tutor2, MotifSyll_Tutor)
                            TutorBoutCn2 = TutorBoutCn2+1;
                            if TutorBoutCn2<11

                                for l = 1:length(MotifSyll_Tutor)
                                    if ~isequal(i,k) || ~isequal(j,l)
                                        TempMotifs_Tutor2 = strfind(BoutLabels_Tutor2,MotifSyll_Tutor(l));
                                        TempSyllOnset_Tutor2 = BoutOnset_Tutor2(TempMotifs_Tutor2(1));
                                        TempSyllOffset_Tutor2 = BoutOffset_Tutor2(TempMotifs_Tutor2(1));
                                        [x2, fs2] = audioread(BoutFiles_Tutor2{k}, [round((TempSyllOnset_Tutor2/1000)*44100) round((TempSyllOffset_Tutor2/1000)*44100)]);

                                        % Ensure both signals have the same sampling rate
                                        if fs1 ~= fs2
                                            error('Sampling rates of the two signals must match!');
                                        end


                                        if size(x2, 1) < round(fs2*0.03)
                                            % Open the file for writing (if it doesn't exist, it will be created)
                                            fileID = fopen([folderPath '/' PupilName{1} '_Error.txt'], 'a');
                                            fprintf(fileID, ['Tutor: ' TutorName{1} ', File: '  BoutFiles_Tutor{i} ', Syllable: ' MotifSyll_Tutor(j) ', Duration too short - SKIPPED \n']);
                                            fclose(fileID);
                                        end

                                        if size(x2, 1) >= round(fs2*0.03)

                                            %   ---------------------------------------
                                            %   Raw wave normalisation

                                            %   1. Bandpass filter - 300Hz & 8000Hz
                                            %      Remove low-frequency noise and high-frequency irrelevant content.

                                            bpFilt = designfilt('bandpassiir','FilterOrder',6, 'HalfPowerFrequency1',300,'HalfPowerFrequency2',8000, 'SampleRate',fs1);
                                            x1_Filtered = filtfilt(bpFilt, x1);
                                            x2_Filtered = filtfilt(bpFilt, x2);


                                            %   2. RMS Amplitude normalization
                                            %      Removes the effect of distance between mic and bird

                                            targetRMS = 0.1;
                                            rmsVal = sqrt(mean(x1_Filtered.^2));
                                            x1_norm = x1_Filtered * (targetRMS / rmsVal);

                                            rmsVal = sqrt(mean(x2_Filtered.^2));
                                            x2_norm = x2_Filtered * (targetRMS / rmsVal);

                                            %   ---------------------------------------



                                            %   #3 Mel Frequency Cepstral Coefficients (MFCCs)
                                            %   Calculate MFCCs
                                            MFCCcoeffs1 = mfcc(x1_norm, fs1);
                                            MFCCcoeffs2 = mfcc(x2_norm, fs2);

                                            % Dynamic Time Warping
                                            % Compute DTW distance and path
                                            distMFCC = dtw(MFCCcoeffs1', MFCCcoeffs2');

                                            % Lengths of the MFCC feature matrices
                                            len1 = size(MFCCcoeffs1, 1);  % Number of frames in signal 1
                                            len2 = size(MFCCcoeffs2, 1);  % Number of frames in signal 2

                                            % Normalize DTW distance
                                            normalizedDist = distMFCC / max(len1, len2);


                                            TutorData{NumCn,1} = TutorName;
                                            TutorData{NumCn,2} = BoutFiles_Tutor{i};
                                            TutorData{NumCn,3} = BoutFiles_Tutor2{k};
                                            TutorData{NumCn,4} = TutorBoutCn;
                                            TutorData{NumCn,5} = j;
                                            TutorData{NumCn,6} = MotifSyll_Tutor(j);
                                            TutorData{NumCn,7} = TutorBoutCn2;
                                            TutorData{NumCn,8} = l;
                                            TutorData{NumCn,9} = MotifSyll_Tutor(l);
                                            TutorData{NumCn,10} = normalizedDist;
                                            NumCn = NumCn+1;

                                            Cn = Cn+1;
                                            x = Cn;
                                            y = 10*length(MotifSyll_Tutor)*10*length(MotifSyll_Tutor);
                                            waitbar((x/y)*progressPerStep, f, sprintf(['Calculating tutor syllable variability (1/', num2str(totalSteps), '): %d%%'], floor((x/y)*100)));
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


waitbar(1*progressPerStep, f, sprintf(['Calculating tutor syllable variability (1/', num2str(totalSteps), '): %d%%'], floor((1)*100)));


TutorDataMean = {'Tutor', 'Tutor syll no 1', 'Tutor syll label 1', 'Tutor syll no 2', 'Tutor syll label 2', 'Mean distance', 'Std dev distance', '5 percentile', '95 percentile'};
NumCn = 2;

for j = 1:length(MotifSyll_Tutor)
    for l = 1:length(MotifSyll_Tutor)
        Idx = find(cell2mat(TutorData(2:end,5))==j & cell2mat(TutorData(2:end,8))==l);
        Idx = Idx+1;

        MeanDistance = mean(cell2mat(TutorData(Idx,10)));
        StdDevDistance = std(cell2mat(TutorData(Idx,10)));
        percentile5 = prctile(cell2mat(TutorData(Idx,10)),5);
        percentile95 = prctile(cell2mat(TutorData(Idx,10)),95);

        TutorDataMean{NumCn,1} = TutorName;
        TutorDataMean{NumCn,2} = j;
        TutorDataMean{NumCn,3} = MotifSyll_Tutor(j);
        TutorDataMean{NumCn,4} = l;
        TutorDataMean{NumCn,5} = MotifSyll_Tutor(l);
        TutorDataMean{NumCn,6} = MeanDistance;
        TutorDataMean{NumCn,7} = StdDevDistance;
        TutorDataMean{NumCn,8} = percentile5;
        TutorDataMean{NumCn,9} = percentile95;
        NumCn = NumCn+1;
    end
end


TutorMinDist = [];
TutorMaxDist = [];

for j = 1:length(MotifSyll_Tutor)
    Idx = find(cell2mat(TutorDataMean(2:end,2))==j);
    Idx = Idx+1;
    % MinDist = min(cell2mat(TutorDataMean(Idx,6)));  %   Mean
    % MaxDist = max(cell2mat(TutorDataMean(Idx,6)));  %   Mean

    MinDist = min(cell2mat(TutorDataMean(Idx,8)));  %   5 percentile
    MaxDist = max(cell2mat(TutorDataMean(Idx,9)));  %   95 percentile
    TutorMinDist(end+1) = MinDist;
    TutorMaxDist(end+1) = MaxDist;
end



%   -----------------------------------------------------------------------
%   Tutor - Pupil
%   -----------------------------------------------------------------------

waitbar(1*progressPerStep+0*progressPerStep, f, sprintf(['Calculating similarity (2/', num2str(totalSteps), '): %d%%'], floor(0*100)));
Cn = 0;


Data = {'Tutor', 'Pupil', 'Tutor file name', 'Pupil file name', 'Tutor bout', 'Tutor syll no', 'Tutor syll label', 'Pupil bout', 'Pupil syll no', 'Pupil syll label', 'Distance', 'Similarity'};
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

                if i == 1
                    TutorSyl = x1;
                    AllTutorSyll{i, j} = num2cell(TutorSyl);
                end


                if size(x1, 1) < round(fs1*0.03)
                    % Open the file for writing (if it doesn't exist, it will be created)
                    fileID = fopen([folderPath '/' PupilName{1} '_Error.txt'], 'a');
                    fprintf(fileID, ['Tutor: ' TutorName{1} ', File: '  BoutFiles_Tutor{i} ', Syllable: ' MotifSyll_Tutor(j) ', Duration too short - SKIPPED \n']);
                    fclose(fileID);
                end

                if size(x1, 1) >= round(fs1*0.03)

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

                                    if size(x2, 1) < round(fs2*0.03)
                                        % Open the file for writing (if it doesn't exist, it will be created)
                                        fileID = fopen([folderPath '/' PupilName{1} '_Error.txt'], 'a');
                                        fprintf(fileID, ['Pupil: ' PupilName{1} ', File: '  BoutFiles_Pupil{k} ', Syllable: ' MotifSyll_Pupil(l) ', Duration too short - SKIPPED \n']);
                                        fclose(fileID);
                                    end

                                    if size(x2, 1) >= round(fs2*0.03)


                                        %   ---------------------------------------
                                        %   Raw wave normalisation

                                        %   1. Bandpass filter - 300Hz & 8000Hz
                                        %      Remove low-frequency noise and high-frequency irrelevant content.

                                        bpFilt = designfilt('bandpassiir','FilterOrder',6, 'HalfPowerFrequency1',300,'HalfPowerFrequency2',8000, 'SampleRate',fs1);
                                        x1_Filtered = filtfilt(bpFilt, x1);
                                        x2_Filtered = filtfilt(bpFilt, x2);


                                        %   2. RMS Amplitude normalization
                                        %      Removes the effect of distance between mic and bird

                                        targetRMS = 0.1;
                                        rmsVal = sqrt(mean(x1_Filtered.^2));
                                        x1_norm = x1_Filtered * (targetRMS / rmsVal);

                                        rmsVal = sqrt(mean(x2_Filtered.^2));
                                        x2_norm = x2_Filtered * (targetRMS / rmsVal);

                                        %   ---------------------------------------



                                        %   #3 Mel Frequency Cepstral Coefficients (MFCCs)
                                        %   Calculate MFCCs
                                        MFCCcoeffs1 = mfcc(x1_norm, fs1);
                                        MFCCcoeffs2 = mfcc(x2_norm, fs2);

                                        % Dynamic Time Warping
                                        % Compute DTW distance and path
                                        distMFCC = dtw(MFCCcoeffs1', MFCCcoeffs2');


                                        % Lengths of the MFCC feature matrices
                                        len1 = size(MFCCcoeffs1, 1);  % Number of frames in signal 1
                                        len2 = size(MFCCcoeffs2, 1);  % Number of frames in signal 2

                                        % Normalize DTW distance
                                        normalizedDist = distMFCC / max(len1, len2);


                                        TutorMinDistTemp = TutorMinDist(j);
                                        TutorMaxDistTemp = TutorMaxDist(j);

                                        similarity = 1 - (normalizedDist - TutorMinDistTemp) / (TutorMaxDistTemp - TutorMinDistTemp);
                                        SimilarityPercent = similarity*100;

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
                                        Data{NumCn,11} = normalizedDist;
                                        Data{NumCn,12} = SimilarityPercent;
                                        NumCn = NumCn+1;

                                        Cn = Cn+1;
                                        x = Cn;
                                        y = 10*length(MotifSyll_Tutor)*10*length(MotifSyll_Pupil);
                                        waitbar(1*progressPerStep+(x/y)*progressPerStep, f, sprintf(['Calculating similarity (2/', num2str(totalSteps), '): %d%%'], floor((x/y)*100)));

                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

waitbar(1*progressPerStep+(1)*progressPerStep, f, sprintf(['Calculating similarity (2/', num2str(totalSteps), '): %d%%'], floor((1)*100)));

DataMean = {'Tutor', 'Pupil', 'Tutor syll no', 'Tutor syll label', 'Pupil syll no', 'Pupil syll label', 'Mean similarity', 'Std dev similarity', 'Score'};
NumCn = 2;

for j = 1:length(MotifSyll_Tutor)
    for l = 1:length(MotifSyll_Pupil)
        Idx = find(cell2mat(Data(2:end,6))==j & cell2mat(Data(2:end,9))==l);
        Idx = Idx+1;

        MeanSim = mean(cell2mat((Data(Idx,12))));
        StdDevSim = std(cell2mat((Data(Idx,12))));

        DataMean{NumCn,1} = TutorName;
        DataMean{NumCn,2} = PupilName;
        DataMean{NumCn,3} = j;
        DataMean{NumCn,4} = MotifSyll_Tutor(j);
        DataMean{NumCn,5} = l;
        DataMean{NumCn,6} = MotifSyll_Pupil(l);
        DataMean{NumCn,7} = MeanSim;
        DataMean{NumCn,8} = StdDevSim;
        NumCn = NumCn+1;
    end
end


PercentSimilarity = {'Pupil name', 'Tutor name', 'Mean similarity %', 'Std Dev'};
AllMaxSim = [];

for j = 1:length(MotifSyll_Tutor)
    Idx = find(cell2mat(DataMean(2:end,3))==j);
    Idx = Idx+1;
    MaxSim = max(cell2mat(DataMean(Idx,7)));
    AllMaxSim(end+1) = MaxSim;

    % Score: 1 for max, 0 for others
    score = double(cell2mat(DataMean(Idx,7)) == MaxSim);

    for m = 1:length(Idx)
        DataMean{Idx(m),9} = score(m);
    end
end

PercentSim = nanmean(AllMaxSim);
StdDev = nanstd(AllMaxSim);

PercentSimilarity{2,1} = PupilName;
PercentSimilarity{2,2} = TutorName;
PercentSimilarity{2,3} = PercentSim;
PercentSimilarity{2,4} = StdDev;


%   -----------------------------------------------------------------------
%   Figure
%   -----------------------------------------------------------------------

waitbar(2*progressPerStep+0*progressPerStep, f, sprintf(['Plotting and saving (3/', num2str(totalSteps), '): %d%%'], floor(0*100)));

M = cell2mat(DataMean(2:end,7));
N = cell2mat(DataMean(2:end,9));
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
title([PupilName{1} ' similarity matrix (' num2str(round(PercentSim, 2)) '%)'])
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

waitbar(2*progressPerStep+0.5*progressPerStep, f, sprintf(['Plotting and saving (3/', num2str(totalSteps), '): %d%%'], floor(0.5*100)));
pause(0.5)



%----------------------------   Saving Data  ------------------------------


saveas(gcf, fullfile(folderPath,PupilName{1}))
close(gcf);

save(fullfile(folderPath, [PupilName{1} '_DataMean']), 'DataMean');
save(fullfile(folderPath, [PupilName{1} '_TutorDataMean']), 'TutorDataMean');

waitbar(2*progressPerStep+1*progressPerStep, f, sprintf(['Plotting and saving (3/', num2str(totalSteps), '): %d%%'], floor(1*100)));
pause(0.5)

waitbar(1,f,'Finishing');   %   updates the length of waitbar to 100% and display 'Finishing'
pause(0.5)      %      pause for 0.5 sec before continuing
close(f)