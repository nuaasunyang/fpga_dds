clc
clear
for t=1:1:512
    %sin赋值
    if((t>=1 && t<=13) || (t>=244 && t<=512))
        sin(t)=0;
    else if(t>=14 && t <=243)
        sin(t)=1; 
        end
    end
    %sin_n赋值
    if((t>=1 && t<=269) || (t>=500 && t<=512))
        sin_n(t)=0;
    else if(t>=270 && t <=499)
        sin_n(t)=1; 
        end
    end
   %cos赋值
    if((t>=1 && t<=141) || (t>=372 && t<=512))
        cos(t)=0;
    else if(t>=142 && t <=371)
        cos(t)=1; 
        end
    end
    %cos_n赋值
    if((t>=1 && t<=115) || (t>=398 && t<=512))
        cos_n(t)=1;
    else if(t>=116 && t <=397)
        cos_n(t)=0; 
        end
    end    
end

%sin1写入Mif
sin1 = fopen('sin1.mif','w');
fprintf(sin1,'%s\n','WIDTH = 1;');
fprintf(sin1,'%s\n','DEPTH = 512;');
fprintf(sin1,'%s\n','ADDRESS_RADIX=UNS;');
fprintf(sin1,'%s\n','DATA_RADIX=UNS;');
fprintf(sin1,'%s\n','CONTENT BEGIN;');
for i=1:512
   fprintf(sin1, '%d',i-1);            %address
   fprintf(sin1, '%s',' : '); 
   fprintf(sin1, '%d',sin(i));
   fprintf(sin1, '%s\n',' ; '); 
end
fprintf(sin1,'END;\n');
fclose(sin1);

%sin2写入Mif
sin2 = fopen('sin2.mif','w');
fprintf(sin1,'%s\n','WIDTH = 1;');
fprintf(sin2,'%s\n','DEPTH = 512;');
fprintf(sin1,'%s\n','ADDRESS_RADIX=UNS;');
fprintf(sin1,'%s\n','DATA_RADIX=UNS;');
fprintf(sin1,'%s\n','CONTENT BEGIN;');
for i=1:512
   fprintf(sin2, '%d',i-1);            %address
   fprintf(sin2, '%s',' : '); 
   fprintf(sin2, '%d',sin_n(i));
   fprintf(sin2, '%s\n',' ; '); 
end
fprintf(sin2,'%s\n','END ;');
fclose(sin2);

%cos1写入Mif
cos1 = fopen('cos1.mif','w');
fprintf(sin1,'%s\n','WIDTH = 1;');
fprintf(cos1,'%s\n','DEPTH = 512;');
fprintf(sin1,'%s\n','ADDRESS_RADIX=UNS;');
fprintf(sin1,'%s\n','DATA_RADIX=UNS;');
fprintf(sin1,'%s\n','CONTENT BEGIN;');
for i=1:512
   fprintf(cos1, '%d',i-1);            %address
   fprintf(cos1, '%s',' : '); 
   fprintf(cos1, '%d',cos(i));
   fprintf(cos1, '%s\n',' ; '); 
end
fprintf(cos1,'%s\n','END ;');
fclose(cos1);

%cos2写入Mif
cos2 = fopen('cos2.mif','w');
fprintf(sin1,'%s\n','WIDTH = 1;');
fprintf(cos2,'%s\n','DEPTH = 512;');
fprintf(sin1,'%s\n','ADDRESS_RADIX=UNS;');
fprintf(sin1,'%s\n','DATA_RADIX=UNS;');
fprintf(sin1,'%s\n','CONTENT BEGIN;');
for i=1:512
   fprintf(cos2, '%d',i-1);            %address
   fprintf(cos2, '%s',' : '); 
   fprintf(cos2, '%d',cos_n(i));
   fprintf(cos2, '%s\n',' ; '); 
end
fprintf(cos2,'%s\n','END ;');
fclose(cos2);