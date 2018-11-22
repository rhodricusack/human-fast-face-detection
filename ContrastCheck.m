scriptpth=fileparts(mfilename('fullpath'));
categories={'Faces','Houses'};

% Reference size for contrast
% sz=256;

for n = 1:2
    
    filelist = dir(fullfile(scriptpth,categories{n},'*jpg'));
    
    for i=1:length(filelist)
        % Arrays for output
        if i==1 && n==1
            totpix=nan(2,length(filelist));
            cont=nan(2,length(filelist));
        end
        
        
        %read in the images
        im = imread(fullfile(scriptpth,categories{n},filelist(i).name));
    
        % Reference size for contrast, assume that stimuli are squares
        sz=size(im,1);
        
        im=double(im)/255; 
                           
        %contrast
        cont(n,i)=sum(1-im(:))/(sz*sz);
        
    end
    
    % Summary
    mn_cont=mean(cont(n,:));
    sd_cont=std(cont(n,:));
    
    fprintf('%s: number of pixels %f+/-%f, contrast %f+/-%f\n',categories{n},mn_totpix,sd_totpix,mn_cont,sd_cont);
    
end

[h p]=ttest2(cont(1,:),cont(2,:));
fprintf('Faces vs. houses, cont p<%f\n',p);
        