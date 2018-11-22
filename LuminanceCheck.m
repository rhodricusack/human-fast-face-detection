%% Written by Laura Cabral and Rhodri Cusack, 2018

scriptpth=fileparts(mfilename('fullpath'));
categories={'Faces','Houses'};


for n = 1:2
    
    filelist = dir(fullfile(scriptpth,categories{n},'*jpg'));
    
    for i=1:length(filelist)
        % Arrays for output
        if i==1 && n==1
            totpix=nan(2,length(filelist));
            lum=nan(2,length(filelist));
        end
        
        
        %read in the images
        im = imread(fullfile(scriptpth,categories{n},filelist(i).name));
    
        im=double(im)/255; 
                           
        %luminance
        lum(n,i)=mean(im(n,i));
        
    end
    
end

[h p]=ttest2(lum(1,:),lum(2,:));
fprintf('Faces vs. houses, lum p<%f\n',p);
        