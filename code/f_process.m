function output = f_process(input, flag)
%Process image, if flag is set to 0 then read in images otherwise just resize
    %   Detailed explanation goes here
    
numberOfImages = length(input);
imgOutput = cell(1,numberOfImages);

%Read in images & resize
for i = 1 : numberOfImages
    if flag == 0
        imgOutput{:,i} = imread(input{:,i});
    else % resize
        imgOutput{:,i} = imresize(input{:,i}, 0.2);
    end
    
end

%return image_fft
output = imgOutput;
end

