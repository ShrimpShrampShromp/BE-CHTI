function  Wav2ASM( NomFichier )

if (exist([NomFichier,'.wav'])~=2)
    disp('Ce fichier son n''existe pas...')
else
    [Son,Fe] =wavread([NomFichier,'.wav']);
    sound(Son,Fe);
    temps = [0:size(Son,1)-1]/Fe;
    plot(temps,Son);
    
    
    Tmin = input('Temps du début du son : ');
    Tmax = input('Temps de la fin du son : ');

    Selec = find( (temps  > Tmin) & (temps < Tmax))
    
    if (size(Selec,2) > 16000)
        Selec = Selec(1:16000)
        disp('Trop grand...j''ai coupé!')
    end
    
    
    Tchion = Son(Selec);

    SigMax = max(abs(Tchion));

    plot(temps(Selec),int16(Tchion*32767/SigMax));

    sound(Tchion,Fe);

    fileID = fopen([NomFichier,'.asm'], 'w');
 
    fprintf(fileID,';*********************************************\n');
    fprintf(fileID,'\n\t\t AREA SecSon, DATA, READONLY \n ');
    fprintf(fileID,';*********************************************\n');
    fprintf(fileID,'\t\t export LongueurSon \n');
    fprintf(fileID,'\t\t export PeriodeSonMicroSec \n');
    fprintf(fileID,'\t\t export Son \n');
    
    fprintf(fileID,'LongueurSon	 DCD %d \n',size(Selec,2));
    fprintf(fileID,'PeriodeSonMicroSec	 DCD %d \n',int32(round(1e6/Fe)));
    fprintf(fileID,'Son \n');
    
   
    for  Indice = 1 : size(Selec,2)
        fprintf(fileID,'\t DCW \t %7d\n',int16(Tchion(Indice)*32767/SigMax));
    end

    fprintf(fileID,'\tEND     \n ');
    fclose(fileID);

end
end


