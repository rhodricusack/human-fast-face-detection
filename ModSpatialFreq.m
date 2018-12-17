% Laura Cabral and Rhodri Cusack BMI Western
% v1 2015-03-06: Modifying Spatial Frequency of Houses and Faces
scriptpth=fileparts(mfilename('fullpath'));
categories={'Faces_Spatial','Houses_Spatial', 'tFaces', 'tHouses'};

%drstore=zeros(1224,48);
%%We need to run the function before we can calculate fhpowratio
% Use a cell array as there maybe different numbers of Faces and Houses
pow=cell(2,1);
%%This is the code we need to run to get the fpow and hpow values
for n = 1:2 %loop over face n=1 and houses n=2
    
    filelist = dir(fullfile(scriptpth,categories{n},'*jpg'));
    
    for i=1:length(filelist)
        %read in the images
        im = imread(fullfile(scriptpth,categories{n},filelist(i).name));
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
        if (i==1)
            %calculate the width and height
            w=size(im,2);
            h=size(im,1);
            %calculate the distance
            
            
            [x,y]= ndgrid(1:w, 1:h);
            d=((x-(w/2+1)).^2+ (y-(h/2+1)).^2).^0.5;
            dr= round(d);
            pow{n}=zeros(length(filelist),max(dr(:))+1);
        end

        
        %The last step

        for dist = 0:max(dr)
            pow{n}(i,dist+1)= sum(fim(dr==dist));
        end       
    end
    
end


fpow=mean(pow{1});
hpow=mean(pow{2});
fhpowratio=fpow./hpow;



for n = 1:2 %loop over faces and houses n=1 and n=2
    filelist = dir(fullfile(scriptpth,categories{n},'*jpg'));
    if (n==2)
        ratio=fhpowratio.^0.5;
    else
        ratio=1./(fhpowratio.^0.5);
    end
    
    for i=1:length(filelist)
        %read in the images
        im = imread(fullfile(scriptpth,categories{n},filelist(i).name));
        %fft the images
        fim=fft2(im);
        %rearragnge the quadrants 
        fim_orig=fftshift(fim);
        fim=fim_orig;
        
        %lets take the power of the real and imaginary parts
        %the last step
        for dist = 0:max(dr)
            fim(dr==dist)=fim(dr==dist)*ratio(dist+1);
        end
        imt=ifft2(ifftshift(fim));
        
        % Real part only
        imt=real(imt);
        % Max should be 1.0
        imt=imt/max(imt(:));
        % Write out
        imwrite(imt,fullfile(scriptpth,categories{n+2},[num2str(i),'.jpg']));  
        
        % Some checking
        figure(10+n)
        subplot 321
        imagesc(im)
        subplot 322
        imagesc(log(abs(fim_orig)))
        subplot 323
        semilogy(ratio);
        ylabel('Log ratio');
        xlabel('Spatial frequency');
        subplot 324
        imagesc(log(abs(fim)))
        subplot 325
        imagesc(real(imt));
        colormap('gray')
        subplot 326
        imagesc(log(abs(fim)./abs(fim_orig)));
        colormap('gray')
    end

end







