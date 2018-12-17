% Laura Cabral and Rhodri Cusack BMI Western
% v1 2015-03-05: Calculating Spatial Frequency of Houses and Faces
%May 13 2016 changed code to have a different downsample factor of 8 (a
%multiple of 512. Changed plot at the end to have a different x and y axis
%changed plot to be sd instead of se

% On my computer it isn't in ~/Dropbox so I've added this...
scriptpth=fileparts(mfilename('fullpath'));
categories={'tFaces','tHouses'};

%drstore=zeros(1224,48);

% Use a cell array as there maybe different numbers of Faces and Houses
pow=cell(2,1);

dsfactor=8;

% Check code
dummydata_check_sf=false;
dummydata_horz_cycles_per_image=0;
dummydata_vert_cycles_per_image=5;

for stimtype = 1:2 %loop over face n=1 and houses n=2
    
    % I prefer specifying the full path, rather than changing directory, as
    % I find it rude when scripts leave me in a different place.
    filelist = dir(fullfile(scriptpth,categories{stimtype},'*jpg'));
    
    for imnum=1:length(filelist)
        %read in the images
        im_input = double(imread(fullfile(scriptpth,categories{stimtype},filelist(imnum).name)));


        if dummydata_check_sf
            [y x]=ndgrid(1:size(im_input,1),1:size(im_input,2));
            im_input=sin(2*pi*(dummydata_vert_cycles_per_image*y/size(im_input,1) + dummydata_horz_cycles_per_image*x/size(im_input,2)));  
        end;

        % downsample
        sz_input=size(im_input);
        sz=floor(sz_input/dsfactor);
        
        im=zeros(sz);
        for offsetx=1:dsfactor
            for offsety=1:dsfactor
                im=im+im_input(offsetx:dsfactor:sz(1)*dsfactor,offsety:dsfactor:sz(2)*dsfactor);
            end;
        end;
        
        %fft the images
        fim=fft2(im);
        %rearragnge the quadrants 
        fim=fftshift(fim);
        
        %I forgot this, lets take the power of the real and imaginary parts
        fim=abs(fim);

        % If it is our first image then initliaze the output array (assumes
        % all images are same size). And, in fact, we only need to
        % calculate the distances once too - and this is without a doubt
        % the slowest part (square roots are always slow)
        if (imnum==1)
            %calculate the width and height
            w=size(im,2);
            h=size(im,1);
            %calculate the distance
            
            % oops sorry this should have been ndgrid not ngrid
            [x,y]= ndgrid(1:w, 1:h);
            d=((x-(w/2+1)).^2+ (y-(h/2+1)).^2).^0.5;
            dr= round(d);
            pow{stimtype}=zeros(length(filelist),max(dr(:))+1);
        end;

        
        %The last step
%   drstore(:,((mod(1,n)*24)+i))=dr;
%   This is a clever line, but I think we don't need it provided the images are all the same size?

        for dist = 0:max(dr)
            pow{stimtype}(imnum,dist+1)= sum(fim(dr==dist));
        end       
    end
    
    
    % Figures
    figure(11)
    subplot(2,2,stimtype)
    plot(pow{stimtype}');
    title(categories{stimtype})
    xlabel('Spatial freq');
    ylabel('Power');
    
    
end

%% Final plot with cycles/pixel
figure(13); clf
% Same thing but mean/se
%errorbar([mean(pow{1});mean(pow{2})]',[std(pow{1})/sqrt(size(pow{1},1));std(pow{2})/sqrt(size(pow{2},1))]');
% Same thing but mean/st dev
xlabs=[0:45]'/512;
errorbar(repmat(xlabs,[1 2]),[mean(pow{1});mean(pow{2})]',[std(pow{1});std(pow{2})]');
legend({'Faces','Houses'},'FontSize',12)
xlim([0 45]/512);
xlabel('Spatial freq (cycles/pixel)','FontSize',12);
ylabel('Power (a.u.)','FontSize',12);

%% Show dummy testcard
if dummydata_check_sf
    figure(15)
    imagesc(im_input)
    colormap gray
end;

%% Final plot with cycles per image
figure(14); clf
xlabs=[0:45]';
errorbar(repmat(xlabs,[1 2]),[mean(pow{1,:});mean(pow{2,:})]',[std(pow{1,:});std(pow{2,:})]');
legend({'Faces','Houses'},'FontSize',12)
xlabel('Spatial freq (cycles/image)','FontSize',12);
ylabel('Power (a.u.)','FontSize',12);
