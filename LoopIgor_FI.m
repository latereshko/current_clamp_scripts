% Specify the folder to analyse
myFolder = uigetdir();
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
% Get a list of all files in the folder of a specfic name pattern
filePattern = fullfile(myFolder, 'Cell*.ibw'); % Change to whatever pattern you need.
filelist = dir(filePattern);
filesread=[]

for k = 1 : length(filelist)
baseFileName = filelist(k).name;
fullFileName = fullfile(myFolder, baseFileName);
fprintf(1, 'Now reading %s\n', fullFileName);
% read all Igor Cell files into Matlab
[filesread] = IBWread(fullFileName);
[spikes] = GetSpikes(filesread.dx * 1000,filesread.y,  'plotSubject', false, 'debugPlots', false, 'minSpikeHeight', 5);
freqs = getfield(spikes,'frequencies');
freqs_save(k,1:length(freqs)) = freqs;
times = getfield(spikes,'times');
times_save(k,1:length(times)) = times;
wavesY(:,k) = filesread.y;
header = extractfield(filelist,'name');
fclose('all')
end


% for k = 1 : length(filelist)
%   figure
%   plot (wavesY(:,k));
%   hold on;
%   header = extractfield(filelist,'name');
%   % close open files otherwise Matlab will crash
%   fclose('all')
% end

%plot only pulse for a subset of waves

%for k = 251 : 325
%  figure
%  plot(wavesY(8000:20000,k));
%  hold on;
%  header = extractfield(filelist,'name');
  % close open files otherwise Matlab will crash
%  fclose('all')
%end


% Label the loop output with corresponding Cell file name
%labeledtable = [header;num2cell(wavesY)];
%close all open figures
%%%close all
%plot individual waves by columns
%%%plot (wavesY(:,39))
%plot multiple columns on one figure
%%%plot (wavesY(:,[224:233]));


%opengl('save', 'software') command. For more information, see Resolving
%Low-Level Graphics Issues. 