% Show greyscale distribution of four stimulus classess
% Rhodri Cusack Trinity College Dublin 2018-12-17
% rhodricusack@gmail.com

scriptpth=fileparts(mfilename('fullpath'));
% List of conditions
catnames={'Faces Intact','Faces Scrambled','Houses Intact','Houses Scrambled'};
categories={'Faces','Faces','Houses','Houses'};
filter={'*01.jpg','*38.jpg','*01.jpg','*38.jpg'};
cols=[1 0 0; 0.5 0 0; 0 0 1; 0 0 0.5];
% Which pairs of conditions to test against each other
comparisons=[1 2; 3 4; 1 3];

% Grayscale histogram points
histbins=[0:8:256];
histbins_centres=([0 histbins(1:end-1)]+histbins)/2
% Reference size for contrast
% sz=256;


lumhist=[];

figure(20);
clf

% Mean and standard deviation of image histograms
mn=[];
sd=[];

for n = 1:4
    
    lumhist{n}=[];
    filelist = dir(fullfile(scriptpth,categories{n},filter{n}));
    
    for i=1:length(filelist)
        % Arrays for output
        if i==1 && n==1
            totpix=nan(2,length(filelist));
            cont=nan(2,length(filelist));
        end
        
        
        %read in the images
        im = imread(fullfile(scriptpth,categories{n},filelist(i).name));

        %
        lhist=cumsum(hist(double(im(:)),histbins));
        lumhist{n}(end+1,:)=lhist;
        
        % Reference size for contrast, assume that stimuli are squares
        sz=size(im,1);
        
        im=double(im)/255;
       
    end
    

    
    % fprintf('%s: number of pixels %f+/-%f, contrast %f+/-%f\n',categories{n},mn_totpix,sd_totpix,mn_cont,sd_cont);
    
    numpix=length(im(:));
            
    mn(n,:)=mean(lumhist{n})/numpix;
    sd(n,:)=std(lumhist{n})/numpix;
end;

% Plot image 
pl=[];
figure(20)
for n=1:4
    pl(n)=plot(histbins_centres',(mn(n,:)'),'Color',cols(n,:))
    hold on 
    patch([histbins_centres';flip(histbins_centres')],([mn(n,:)'+sd(n,:)';flip(mn(n,:)'-sd(n,:)')]),cols(n,:),'FaceAlpha',0.2,'EdgeColor','none');
end

% Add legend
legend(pl,catnames,'Location','NorthWest')
xlabel('Greyscale brightness');
ylabel('Cumulative proportion of pixels');



fprintf('Proportion of pixels non-white\n');
for n=1:4
    fprintf('%s\t%f\n',catnames{n},mn(n,end-1));
end;
