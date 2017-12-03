function [contClassifiedStuff] = poista_turhat_pisteet(contClassifiedStuff)
        d = 1;    
    if strcmp(contClassifiedStuff(d).name,'.')== 1 % tulee 1 jos samat
            contClassifiedStuff(d) = [];      
    if strcmp(contClassifiedStuff(d).name,'..')== 1 % tulee 1 jos samat
            contClassifiedStuff(d) = []; 
        end
end
end