clc

N = input('Nombre de points : ');
K = 32768;
Theta = [0 : 2*pi/N: 2*pi];

fileID = fopen(['Trigo.asm'], 'w');
fprintf(fileID,'\tAREA Trigo, DATA, READONLY\n');
fprintf(fileID,'\texport TabSin\n');
fprintf(fileID,'\texport TabCos\n\n');

fprintf(fileID,'TabCos\n');
for  i = 1: N
    Sig = K * cos(2*pi*(i-1)/N);
    iSig = int16(Sig);
    if    ( iSig >= 0 )
          xSig = int16( Sig );
    else
          Sig = 65536.0 + Sig;
          xSig = uint16( Sig );
    end
    fprintf( fileID,'\tDCW\t%5d\t; %2d 0x%04x %8.5f\n', iSig, i-1, xSig, double(iSig) / 32768.0 );
end
    
 fprintf(fileID,'TabSin \n');
 for  i = 1: N
    Sig = K * sin(2*pi*(i-1)/N);
    iSig = int16(Sig);
    if    ( iSig >= 0 )
          xSig = int16( Sig );
    else
          Sig = 65536.0 + Sig;
          xSig = uint16( Sig );
    end
    fprintf( fileID,'\tDCW\t%5d\t; %2d 0x%04x %8.5f\n', iSig, i-1, xSig, double(iSig) / 32768.0 );
 end
 
 fprintf(fileID,'\n\tEND\n');
 
 fclose(fileID);