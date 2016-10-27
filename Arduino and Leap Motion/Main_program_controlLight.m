run = 1; %Variable booleana per fer correr el bucle principal
ardBt= Bluetooth('Arduino1',1);
openAndClose =0;
if  ~isempty(ardBt)
    fopen(ardBt);
end
extendedFingers = 0; %Variable que compta els dits allargats

state ='close';

...tancat
%Inicialitzem els pins de l'Arduino
firstTime =1;
firstTime2=1;
%Bucle Principal
outOpen=0;
outClose=0;
okDone=0;
okDone2=0;
h = figure;
while ishandle(h)
  metaData =  matleap_frame; %Agafem Dades 
  if ~isempty(metaData.pointables) 
     %Comptador de dits
    for i=1:length(metaData.pointables)
      extendedFingers=extendedFingers+metaData.pointables(i).is_extended;    
    end
  end

       if extendedFingers == 5 %Si mes de 2 dits allargats 
           if firstTime == 1 
               firstTime = 0;
               elpasedTime1=tic;
               
           elseif toc(elpasedTime1) >= 0.75 %Contador de dos segons
                   firstTime =1;
                   okDone=1;
           end
       elseif firstTime ==0
           firstTime =1;
       end      
       
       if extendedFingers == 2 %Si mes de 2 dits allargats 
           if firstTime2 == 1 
               firstTime2 = 0;
               elpasedTime2=tic;
               
           elseif toc(elpasedTime2) >= 0.75 %Contador de dos segons
                   firstTime2 =1;
                   okDone2=1;
           end
       elseif firstTime2 ==0
           firstTime2 =1;
       end  

  if extendedFingers == 5 &&  strcmp(state,'close') && okDone ==1
      openAndClose = 1; % Open Light
        okDone=0;
  elseif extendedFingers == 2 && strcmp(state,'open') && okDone2==1
      openAndClose = 2; % Close Light
      okDone2=0;
  end
      
  % Switch que analitza els 6 possibles estats
  switch openAndClose
      case 1 % cap dit allargat
         fwrite(ardBt,1); %Make Open light
         state = 'open';
         okDoneIt =0;
      case 2 %1 dit allargat
         fwrite(ardBt,2); %Make Close light
         state = 'close';
         okDoneIt=0;
  end        

pause(0.0000001);   
extendedFingers =0;
end
fwrite(ardBt,2);
fclose(ardBt);

