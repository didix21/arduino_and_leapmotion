%Programa que compta el número de dits allargats d'una mà
run = 1; %Variable booleana per fer correr el bucle principal
arduinoUno = arduino('COM4'); %Connectem amb Arduino
extendedFingers = 0; %Variable que compta els dits allargats
%Inicialitzem els pins de l'Arduino
if ~isempty(arduinoUno) 
    arduinoUno.pinMode(3,'output');
    arduinoUno.pinMode(4,'output');
    arduinoUno.pinMode(5,'output');
    arduinoUno.pinMode(6,'output');
    arduinoUno.pinMode(7,'output');
end
%Bucle Principal
while run
  metaData =  matleap_frame; %Agafem Dades 
  if ~isempty(metaData.pointables) && ~isempty(arduinoUno)
     %Comptador de dits
    for i=1:length(metaData.pointables)
      extendedFingers=extendedFingers+metaData.pointables(i).is_extended;    
    end
  end
  % Switch que analitza els 6 possibles estats
  switch extendedFingers
      case 0 % cap dit allargat
           arduinoUno.digitalWrite(3,0);
            arduinoUno.digitalWrite(4,0);
              arduinoUno.digitalWrite(5,0);
                arduinoUno.digitalWrite(6,0);
                  arduinoUno.digitalWrite(7,0);
      case 1 %1 dit allargat
          arduinoUno.digitalWrite(3,1);
            arduinoUno.digitalWrite(4,0);
              arduinoUno.digitalWrite(5,0);
                arduinoUno.digitalWrite(6,0);
                  arduinoUno.digitalWrite(7,0);
      
      case 2 %2 dits allargats
          arduinoUno.digitalWrite(3,1);
            arduinoUno.digitalWrite(4,1);
              arduinoUno.digitalWrite(5,0);
                arduinoUno.digitalWrite(6,0);
                  arduinoUno.digitalWrite(7,0);
          
      case 3 %3 dits allargats
             arduinoUno.digitalWrite(3,1);
            arduinoUno.digitalWrite(4,1);
              arduinoUno.digitalWrite(5,1);
                arduinoUno.digitalWrite(6,0);
                  arduinoUno.digitalWrite(7,0);
      
      case 4 %4 dits allargats
          arduinoUno.digitalWrite(3,1);
            arduinoUno.digitalWrite(4,1);
              arduinoUno.digitalWrite(5,1);
                arduinoUno.digitalWrite(6,1);
                  arduinoUno.digitalWrite(7,0);
      case 5 %5 dits allargats
           arduinoUno.digitalWrite(3,1);
            arduinoUno.digitalWrite(4,1);
              arduinoUno.digitalWrite(5,1);
                arduinoUno.digitalWrite(6,1);
                  arduinoUno.digitalWrite(7,1);
      otherwise %Més de cinc dits allargats
          run = 0; %Para el programa
  end        
   extendedFingers = 0;   
   
end
clear all;
    