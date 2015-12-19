%Get image files
images = f_readInImages();

%########## IMAGE PROCESSING STARTS HERE ###########

% Variables för image processing.
numberOfImages = length(images);
images_resized = cell(1,numberOfImages);
image_histeq = cell(1,numberOfImages);
image_contrast = cell(1,numberOfImages);

%Methods for processing.
%Read in images
images = f_process(images, 0);

% normalization / resize / fft
image_fft = f_fastfourier(images);
images_resized = f_process(image_fft, 1); % resize

%Get reference image to a variable
for i = 1 : numberOfImages
    %Get refimage and saves it to a variable
    %2 = refimage
    if i == 2
        ref_image_hist = imhist(images_resized{:,i});
        ref_image = images_resized{:,i};
        imwrite(ref_image,'refimage.png'); %Save refimage.
    end
end

%Histogram eq on all images with ref_image_hist.
for i = 1 : numberOfImages
    image_histeq{:,i} = histeq(images_resized{:,i}, ref_image_hist);
end

%Clear some old arrays
clearvars image_fft images ref_image images_resized;

% Contrast stretching
for i = 1 : numberOfImages
    %image_contrast{:,i} = imsharpen(image_histeq{:, i});
    image_contrast{:,i} = imadjust(image_histeq{:, i});
    
    % figure, imshow(image_contrast{:,i}), impixelinfo;
    
    % Treshhold
    gt = graythresh( image_contrast{:,i} );
    gtim = im2bw(image_contrast{:,i}, gt);
    
    SE = strel('disk' ,5);
    im = gtim - (imerode(gtim, SE));
    [k, l]=size(image_contrast{:,i});
    
    f1 = find(image_contrast{:,i} < (90/255));
    fr = zeros(size(image_contrast{:,i}));
    fr(f1)=255/255;
    
    new=zeros(k,l,3);
    new(:,:,1)=fr;
    new(:,:,2)=fr;
    new(:,:,3)=fr;
    new = rgb2gray(new);
    
    %     figure, imshow(im), title(i), impixelinfo;
    %     figure, imshow(~gtim), title(i), impixelinfo;
    
    %  Do tha canny thing.  
    image_after_canny = f_canny(new, 1/255, 20/255);
    
    clearvars f1 fb fg fr gt k l;
    %     figure, imshow(image_after_canny), title(i), impixelinfo;
    
    image_after_canny = bwmorph(image_after_canny, 'bridge');
    image_after_canny = imdilate(image_after_canny, SE);
    
    %Add  polygons to reduce noise.
    c = [0 1659 1659 0];
    r = [0 0 1507 1507];
    
    polyXmid = [673 679 935 995 1150 1201 1213];
    polyYmid = [927 1117 1069 937 820 835 650];
    
    c2 = [1100 1113 1243 1233];
    r2 = [640 747 729 615];
    
    c3 = [723 749 913 911];
    r3 = [863 957 935 843];
    
    c4 = [697 789 865 973 961];
    r4 = [1053 1011 1050 939 1165];
    
    
    BW = roipoly(image_after_canny, c, r);
    poymid = roipoly(image_after_canny, polyXmid, polyYmid);
    
    BW2 = roipoly(image_after_canny, c2, r2);
    BW3 = roipoly(image_after_canny, c3, r3);
    BW4 = roipoly(image_after_canny, c4, r4);
    
    BW(poymid)=0;
    BW2(poymid)=0;
    BW3(poymid)=0;
    BW4(poymid)=0;
    
    BW = ~BW;
    
    BW2 = BW2 .* BW3 .* BW4;
    BW2 = BW .* ~BW2;
    
    image_after_canny = BW2 .* image_after_canny;
    
    
    % Kör lite olika grejer för att tabort onödigt brus runt flodkanter.
    SE2 = strel('disk' ,3);
    
    SE4 = strel('disk' ,1);
    SE5 = strel('disk', 2);
    
    image_after_canny = bwmorph(image_after_canny, 'bridge', Inf);
          
    image_after_canny = bwmorph(image_after_canny, 'majority');
         
    image_after_canny = bwmorph(image_after_canny, 'bridge', Inf);
           
    image_after_canny = imerode(image_after_canny, SE);
    image_after_canny = imdilate(image_after_canny, SE);
    image_after_canny = imdilate(image_after_canny, SE);
    image_after_canny = imerode(image_after_canny, SE);
    image_after_canny = imerode(image_after_canny, SE4);
                 
    image_after_canny = bwmorph(image_after_canny, 'remove'); 
    image_after_canny = bwmorph(image_after_canny, 'clean'); 
           
    SE3 = strel('line', 10, 90);
    image_remove_Edgde = imerode(image_after_canny, SE3);
    image_remove_Edgde = imdilate(image_remove_Edgde, SE4);
    image_after_canny = image_after_canny - image_remove_Edgde;
          
    %Add  polygon to remove edges
    cEdge1 = [660 670 670 660];
    rEdge1 = [0 0 1505 1505];

    cEdge2 = [1214 1231 1231 1214];
    rEdge2 = [0 0 1505 1505];

    polyXmidEdge1 = [673 679 935 995 1150 1201 1213];
    polyYmidEdge1 = [927 1117 1069 937 820 835 650];

    BWEdge1 = roipoly(image_after_canny, cEdge1, rEdge1);
    poymidEdge = roipoly(image_after_canny, polyXmidEdge1, polyYmidEdge1);

    BWEdge2 = roipoly(image_after_canny, cEdge2, rEdge2);

    BWEdge1(poymidEdge)=0;
    BWEdge2(poymidEdge)=0;

    BWEdge1 = ~BWEdge1;

    %          BWEdge2 = BWEdge2 .* BW3 .* BW4 .* BW5;
    BWEdge2 = BW .* ~BWEdge2;

    image_after_canny = BWEdge2 .* image_after_canny;   
    
    % Seperates river in two lines.
    %          SE3 = strel('line', 16, 90);
    %           image_remove_Edgde = imerode(image_after_canny, SE3);
    
    %          image_remove_Edgde = imdilate(image_remove_Edgde, SE4);
    
    %         image_after _canny = image_after_canny - image_remove_Edgde;
    
    %Save coordiantes as txt file.
    sortingEdges(image_after_canny); % also shows result images
    
    %     figure, imshow(image_after_canny), title(i), impixelinfo;
end
%Clear old arrays.
clearvars image_histeq;
%clear all;

%Display test result.
% for i = 1 : numberOfImages
%    % figure(),imshow( log(1+abs(image_fft{:, i})) );
%     figure, imshow(image_contrast{:,i}), title(i);
% end


