% Filewriter
function new_class = FileWriter(pathTo,whatclass,amount_of_classes,lisattava)
    
    if strcmp(whatclass,'ei asettunut') == 1   % if ei asettunut == true, create new
        new_class = createFolder(pathTo,amount_of_classes);       
        addToClass(pathTo,new_class,lisattava); 
    else
        addToClass(pathTo,whatclass,lisattava); 
    end

 end
    
function addToClass(pathTo,whatclass,lisattava)
    lisattava = char(lisattava);
f = fullfile(pathTo,whatclass,lisattava);
    save(f);
end

function new_class = createFolder(pathTo,amount_of_classes)

% Integer to string and attach it with class string
    int_class_index = amount_of_classes + 1;
    str_class_index = int2str(int_class_index);
    
    new_class = horzcat('class',str_class_index);
    yhdist = horzcat(pathTo,'class',str_class_index);
    
% Create new folder 
  mkdir(yhdist);
    
end
