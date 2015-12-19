function out = func_fastfourier(input)
    %FFT Summary of this function goes here
    %   Detailed explanation goes here

    numberOfImages = length(input);
    image_norm = cell(1,numberOfImages);
    image_fft = cell(1,numberOfImages);

   %Polygon left.
    xPoly1 = [786 11 3 1234]; 
    yPoly1 = [20 2891 4083 12];    
    %Polygon right
    xPoly2 = [2849 797 1265 3337]; 
    yPoly2 = [20 7513 7513 18];    
    %Polygons middle
    %1
    x = [4919 2879 3222 5294]; 
    y = [39 7482 7492 29];     
    %2
    x2 = [6897 4804 5367 7448]; 
    y2 = [18 7492 7472 29]; 
    %3
    x3 = [8150 6933 7440 8330]; 
    y3 = [3291 7528 7520 4068]; 

    midpolyx = [3826 3857 4263 4346]; %Creates an empty space given by the x and y coordinate pairs
    midpolyy = [3578 3932 3964 3662];

    %Normalize / FFT processing on images.
    for i = 1 : numberOfImages
        image_norm{:,i} = double(input{:,i})/255; % normalized images
        ft = fft2(image_norm{:,i});
        ft = fftshift(ft);

        im = image_norm{:,i};
        BW = roipoly(im, x, y);   
        polymid = roipoly(im,midpolyx,midpolyy); 
        
        BW2 = roipoly(im, xPoly1, yPoly1);
        BW3 = roipoly(im, xPoly2, yPoly2);
        BW4 = roipoly(im, x2, y2);
        BW5 = roipoly(im, x3, y3);
        
        BW(polymid)=0; 
        BW2(polymid)=0; 
        BW3(polymid)=0;
        BW4(polymid)=0;
        BW5(polymid)=0;
      
        BW=~BW;
        BW2 = ~BW2;
        BW3 = ~BW3;
        BW4 = ~BW4;
        BW5 = ~BW5;
         
        BW = BW.*BW2.*BW3.*BW4.*BW5;
        clearvars BW2 BW3 BW4 BW5 im;
        noBrouws = BW.*ft;     %Multiply the mask BW with the image in Fourirer domain and put in "norain".
        clearvars BW;
        
         %Converts Fourier-domain to Spatial-domain
        image_brouws_free = real(ifft2(ifftshift(noBrouws)));
        %clearvars noBrouws;
        image_brouws_free=image_brouws_free-min(image_brouws_free(:)); %Normalize the image so that no values are outside the range 0-1
        image_brouws_free=image_brouws_free./max(image_brouws_free(:)); 
        %Save in new array and resize images to 80% of original.
        image_fft{:, i} = image_brouws_free;
        %    figure, subplot(4,2,i), 
        figure, imshow(log(1+abs(ft)),[]), title(i), impixelinfo;
         % imshow(log(1+abs(klar)),[]),figure,     %result
        figure, imshow(log(1+abs(noBrouws)),[]), impixelinfo; 
        %Celar variables and arrays to save RAM.
        clearvars images_resized image_brouws_free noBrouws;
    end
    clearvars xPoly1 yPoly1 xPoly2 yPoly2 x y x2 y2 x3 y3 polymid midpolyx midpolyy ft; 
    %return image_fft
    out = image_fft;   
end

