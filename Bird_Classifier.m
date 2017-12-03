function Bird_Classifier
%% Prepare path and file

% From where to read
pathFrom = 'C:\Users\Tero\Desktop\Mathlab\Machinelearning\Fidecula\';
ident = '*.wav';

% Construct wav_path in order to provide it to audioreader later 
result = horzcat(pathFrom,ident);
wav_path = dir(result);

% Where to create output files
pathTo = 'C:\Users\Tero\Desktop\Mathlab\Machinelearning\ClassifiedStuff\';

% If file exist delete pathTo and its content
if length(dir(pathTo)) > 50
     rmdir ClassifiedStuff s
     pause(60);
end

% Create folder to pathTo path
mkdir('ClassifiedStuff');
f = fullfile('C:\Users\Tero\Desktop\Mathlab\Machinelearning\','ClassifiedStuff');
save(f)

%% Loop through files and test them against references
% Initial this to true to allow adding the first reference to the list 
r = true;
referenssit = {};
s_refeaanet = struct('name',{},'date',{},'bytes',{},'isdir',{},'datenum',{});
curve_lista = {};

for t = 2:length(wav_path) % n�� on testattavia

    testattava = wav_path(t).name; % t�t� pit�is vertailla aiempiin referensseihin 
    y1 = audioread([pathFrom wav_path(t).name]);
    curve1 = harmonic_frequency_seek(y1);
    
    % Seuraavien rivien listat olisi hyv� yhdist��. Referenssilistan p�ivitt�miseen 
    % perustuva koodi tuli rakennettua ensimm�isen�, joten lis�ilin j�lkik�teen kaksi 
    % muuta listaa. L�hinn� laskennan nopeuttamiseksi
    
    if r == true % perustettiinko uusi luokka, jos perustettiin kasvatetaan ref listaa
       referenssit{end+1} = wav_path(t-1).name;   % t-1 hakee aiemman ��nen 
       referenssit = referenssit';
       
       y = audioread([pathFrom wav_path(t-1).name]);
       curve = harmonic_frequency_seek(y);
       
       curve_lista{end+1} = curve;    
       s_refeaanet(end+1) = wav_path(t-1);
       
    end

  for refe = 1:length(referenssit)
        curve = curve_lista{1,refe}(1,:); % hakee referenssi kurvin
        diag = dtw(curve,curve1);
        list(refe,:) = [referenssit(refe),diag]; % t��ll� on aina viimeinen referenssi� vastaava dist
        r = false; % boolean nollaus
  end
%% Decision maker

    % jos referenssi� ei l�ydy ja ovat samanlaisia, tehd��n kansio ja
    % laitetaan molemmat sinne
    [what_class, amount_of_classes] = FileReader_Output(referenssit(refe),pathTo);
    if strcmp(what_class,'ei asettunut') == 1 % nyt tehd��n uusi luokka, jos referenssi� ei l�ydy               
        FileWriter(pathTo,what_class,amount_of_classes,referenssit); % luo kansion ja lis�� sinne 
    end
    
    % saa lis�t� luokkaan jos listan pienin ref diag arvo on alle rajan
    listan_diagit = list(:,2);      % kaikki diagit
    d = cell2mat(listan_diagit);    % muunnos      
    [M,I] = min(d);                 % indeksi, josta pienin l�ytyi
    
    % indeksill� luokka mihin lis�t��n
    listan_referenssit = list(:,1);
    refer = cell2mat(listan_referenssit(I));
    
    if M < 7000
          class = FileReader_Output(refer,pathTo); 
          FileWriter(pathTo,class,amount_of_classes,testattava);
    else
      what_class = 'ei asettunut'; % antaa luvan luoda uusi kansio
      FileWriter(pathTo,what_class,amount_of_classes,testattava); % luo kansion ja lis�� testattavan sinne
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









