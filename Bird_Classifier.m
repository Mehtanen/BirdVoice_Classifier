function Bird_Classifier

% Bird voice classifier is the software that classifies bird voices into the different classes.
% Classifier is based on the idea of unsupervised classification. Cheak README file for comprehensive 
% information of the system.

%% Prepare path and file

% From where to read
pathFrom = 'C:\Users\Tero\Desktop\Mathlab\Machinelearning\Fidecula\';
ident = '*.wav';

% Construct wav_path to provide it to audioreader later 
result = horzcat(pathFrom,ident);
wav_path = dir(result);

% Where to create output files
pathTo = 'C:\Users\Tero\Desktop\Mathlab\Machinelearning\ClassifiedStuff\';

% If file exists delete it and all its content
if length(dir(pathTo)) > 50
     rmdir ClassifiedStuff s
     pause(60);
end

% Create target folder to pathTo 
mkdir('ClassifiedStuff');
f = fullfile('C:\Users\Tero\Desktop\Mathlab\Machinelearning\','ClassifiedStuff');
save(f)

%% Loop through files and test them against references

% Initially this is true to allow adding the first reference to the reference list 
r = true;

% These could be in the same list but I didn't spend extra time to figuring out syntax for that
referenssit = {};
s_refeaanet = struct('name',{},'date',{},'bytes',{},'isdir',{},'datenum',{});
curve_lista = {};

% Loop through the original list of the voices
for t = 2:length(wav_path)

    testattava = wav_path(t).name; 
    y1 = audioread([pathFrom wav_path(t).name]); % Read audiofile
    
 % harmonic_frequency_seek-function was provided for me from Tampere University of Technology.  
    curve1 = harmonic_frequency_seek(y1);        % Calculate harmonic frequencies
    
    % If decision maker established a new class this will be true
    if r == true 
       referenssit{end+1} = wav_path(t-1).name;  
       referenssit = referenssit';
       
       y = audioread([pathFrom wav_path(t-1).name]);

       curve = harmonic_frequency_seek(y);
       
       curve_lista{end+1} = curve;    
       s_refeaanet(end+1) = wav_path(t-1);
       
    end
    
% Loop through reference list to test against everyone of them
  for refe = 1:length(referenssit)
      
      % Get reference curve
        curve = curve_lista{1,refe}(1,:);
        
      % Execute Dynamic Time Warping to calculate difference between reference curve and the curve to be tested  
        diag = dtw(curve,curve1);
        list(refe,:) = [referenssit(refe),diag]; 
        r = false; % reset boolean
  end
  
%% Decision maker

    % If reference curve is not found new class will be established and
    % file will be added there
    [what_class, amount_of_classes] = FileReader_Output(referenssit(refe),pathTo);
    if strcmp(what_class,'ei asettunut') == 1              
        FileWriter(pathTo,what_class,amount_of_classes,referenssit); 
    end
    
    % The system is allowed to add a file to the certain class if
    % difference between reference of class and voice to be tested is small enough
    listan_diagit = list(:,2);      
    d = cell2mat(listan_diagit);       
    [M,I] = min(d);                 
    
    % Index of the class to be added
    listan_referenssit = list(:,1);
    refer = cell2mat(listan_referenssit(I));
    
    % M is warping limit. Smaller value will eventually lead to greater number of classes, 
    % because it raises standards to be "similar" voice 
    if M < 7000
          class = FileReader_Output(refer,pathTo); 
          FileWriter(pathTo,class,amount_of_classes,testattava);
    else
      what_class = 'ei asettunut';                                % allows establishing the new class
      FileWriter(pathTo,what_class,amount_of_classes,testattava); % creates new class and adds file there
      r = true; 

    end
end

%% Plot histogram   

    content_Classfied_Folder = poista_turhat_pisteet(dir(pathTo));
    
    for m = 1:length(content_Classfied_Folder)
         class_name = content_Classfied_Folder(m).name;  
         class_index = m;  
         temp = poista_turhat_pisteet(dir(horzcat(pathTo,class_name)));
         number_of_files = length(temp);
         
         x(m) = class_index;
         z(m) = number_of_files;
    end

    figure(2)
    bar(x,z);
    title('Voices in class');
    
end
















