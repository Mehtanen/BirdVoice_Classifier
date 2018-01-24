
%FileReader 
function [what_class,amount_of_classes] = FileReader_Output(referenssi,pathTo)
 
   % content_Classfield_Folder = subfolder content
   % content_Each_Class        = voices in each subfolder

    what_class = 'ei asettunut';
    
    content_Classfied_Folder = poista_turhat_pisteet(dir(pathTo));
    amount_of_classes = length(content_Classfied_Folder);

 for m = 1:length(content_Classfied_Folder)
     class_name = content_Classfied_Folder(m).name;
     
     % There will be content of each class one at the time
     content_Each_Class = poista_turhat_pisteet(dir(horzcat(pathTo,class_name)));      
     
     for t = 1:length(content_Each_Class)
        if strcmp(content_Each_Class(t).name,referenssi) == 1
            what_class = class_name;
        end
     end
 end
end


