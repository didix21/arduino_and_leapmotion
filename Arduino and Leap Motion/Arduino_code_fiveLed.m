% English: This program counts the number of fingers of a hand extended.
% Catalan: Programa que compta el número de dits allargats d'una mà
run = 1; %Catalan: Variable booleana per fer correr el bucle principal
         %English: Boolean variable used for run the main bucle
arduinoUno = arduino('COM4'); % Catalan: Connectem amb Arduino
                              % English: Connect matlab with arduino
                              % (Select your com)
extendedFingers = 0; % Catalan: Variable que compta els dits allargats
                     % English: Variable that counts the number of fingers
                     % extended.
% Catalan: Inicialitzem els pins de l'Arduino
% English: Init Arduini pins
if ~isempty(arduinoUno) 
    arduinoUno.pinMode(3,'output');
    arduinoUno.pinMode(4,'output');
    arduinoUno.pinMode(5,'output');
    arduinoUno.pinMode(6,'output');
    arduinoUno.pinMode(7,'output');
end
% Catalan: Bucle Principal
% English: Main Bucle
while run
  metaData =  matleap_frame; % Catalan: Agafem Dades 
                             % English: Take data from leap motion
  if ~isempty(metaData.pointables) && ~isempty(arduinoUno)
     % Catalan: Comptador de dits
     % English: Finger counter
    for i=1:length(metaData.pointables)
      extendedFingers=extendedFingers+metaData.pointables(i).is_extended;    
    end
  end
  % Catalan: Switch que analitza els 6 possibles estats
  % English: Switch that analyze 6 differents possible states. 
  switch extendedFingers
      case 0 % Catalan: cap dit allargat
             % English: No finger extended
           arduinoUno.digitalWrite(3,0);
            arduinoUno.digitalWrite(4,0);
              arduinoUno.digitalWrite(5,0);
                arduinoUno.digitalWrite(6,0);
                  arduinoUno.digitalWrite(7,0);
      case 1 % Catalan: 1 dit allargat
             % English: 1 finger extended
          arduinoUno.digitalWrite(3,1);
            arduinoUno.digitalWrite(4,0);
              arduinoUno.digitalWrite(5,0);
                arduinoUno.digitalWrite(6,0);
                  arduinoUno.digitalWrite(7,0);
      
      case 2 % Catalan: 2 dits allargats
             % English: 2 fingers extended
          arduinoUno.digitalWrite(3,1);
            arduinoUno.digitalWrite(4,1);
              arduinoUno.digitalWrite(5,0);
                arduinoUno.digitalWrite(6,0);
                  arduinoUno.digitalWrite(7,0);
          
      case 3 % Catalan: 3 dits allargats
             % English: 3 fingers extended
             arduinoUno.digitalWrite(3,1);
            arduinoUno.digitalWrite(4,1);
              arduinoUno.digitalWrite(5,1);
                arduinoUno.digitalWrite(6,0);
                  arduinoUno.digitalWrite(7,0);
      
      case 4 % Catalan: 4 dits allargats
             % English: 4 fingers extended
          arduinoUno.digitalWrite(3,1);
            arduinoUno.digitalWrite(4,1);
              arduinoUno.digitalWrite(5,1);
                arduinoUno.digitalWrite(6,1);
                  arduinoUno.digitalWrite(7,0);
      case 5 % Catalan: 5 dits allargats
             % English: 5 fingers extended
           arduinoUno.digitalWrite(3,1);
            arduinoUno.digitalWrite(4,1);
              arduinoUno.digitalWrite(5,1);
                arduinoUno.digitalWrite(6,1);
                  arduinoUno.digitalWrite(7,1);
      otherwise % Catalan: Més de cinc dits allargats
                % English: More than 5 fingers extended
          run = 0; % Catalan: Para el programa
                   % English: Stops the program
  end        
   extendedFingers = 0;   
   
end
clear all;
    