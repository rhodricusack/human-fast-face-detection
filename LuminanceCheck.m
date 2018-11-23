%% Written by Laura Cabral 2018

scriptpth=fileparts(mfilename('fullpath'));
categories={'Faces','Houses'};

lum={};
for n=1:2
   lum{n}=[];
    
   filelist = dir(fullfile(scriptpth,categories{n},'*jpg'));
    
   for i=1:length(filelist)
       %read in the images
       im = imread(fullfile(scriptpth,categories{n},filelist(i).name));
    
       im=double(im)/255; 
                           
       %luminance
       lum(n,i)=mean(im(:));
        
    end
    
end

[h p]=ttest2((lum{1}),(lum{2}));
fprintf('Faces vs. houses, lum p<%f\n',p);
        
