%Canny function . input image.
function y = func_canny(image, low, high) 
    %figure, imshow(im);
    %figure, imshow(im),title('Image before Canny');
    grayimage = image;

    %Canny Process..

    % Gaussian filter.

    G = fspecial('gaussian', [3, 3], 1);
    imG = conv2(grayimage, G, 'same');
    %sobel masks.
    Wh = [-1 0 -1; -2 0 2; -1 0 1];
    Wg = [-1 -2 -1; 0 0 0; 1 2 1];

    imgGx = conv2(imG, Wg, 'same');
    imgGy = conv2(imG, Wh, 'same');
    grad_im = abs(imgGx) + abs(imgGy);
    
    %figure, imshow(grad_im), impixelinfo;
    
    grad_angle = atan(imgGy./imgGx);
    grad_deg = floor(grad_angle / (pi/180));
    min_angle = min(grad_angle(:));
    
    %fprintf('min angle is equal to %s\n',num2str(min_angle));
    
    if min_angle < 0
        grad_deg = grad_deg + 180.0;
       % fprintf('min angle is equal to %s\n',num2str(grad_deg));
    end

    %Quantization
    [m, n] = size(grad_deg);
    out_angle = zeros(m, n);
    for x = 2 : m - 1
        for y = 2 : n - 1
            if (0 < grad_deg(x, y) && grad_deg(x, y) <= 22.5) || (157.5 < grad_deg(x, y) && grad_deg(x, y) <= 202.5) || (337.5 < grad_deg(x, y) && grad_deg(x, y) <= 360)
                out_angle (x, y ) = 0;
            elseif (22.5 < grad_deg(x, y) && grad_deg(x, y) <= 67.5) || (202.5 < grad_deg(x, y) && grad_deg(x, y) <= 247.5)
                out_angle (x, y ) = 1;
            elseif (67.5 < grad_deg(x, y) && grad_deg(x, y) <= 112.5) || (247.5 < grad_deg(x, y) && grad_deg(x, y) <= 292.5)
                out_angle (x, y ) = 2;
            elseif (112.5 < grad_deg(x, y) && grad_deg(x, y) <= 157.5) || (292.5 < grad_deg(x, y) && grad_deg(x, y) <= 337.5)
                out_angle (x, y ) = 3;
            end
        end      
    end

    %Non-maximum suppresion
    %(out_angle(x, y) == 2 && (grad_im(x, y) >= grad_im(x, y - 1) && grad_im(x, y) >= grad_im(x, y + 1)))
    %(out_angle(x, y) == 1 && (grad_im(x, y) >= grad_im(x - 1, y - 1) && grad_im(x, y) >= grad_im(x + 1, y + 1))))
    %(out_angle(x, y) == 0 && (grad_im(x, y) >= grad_im(x - 1, y) && grad_im(x, y) >= grad_im(x + 1, y))))
    %
    out_non_max = zeros (m, n);
    for x = 2 : m - 1
        for y = 2 : n - 1
            if(out_angle(x, y) == 1 && (grad_im(x, y) >= grad_im(x, y - 1) && grad_im(x, y) >= grad_im(x, y + 1))) ||...
                    (out_angle(x, y) == 2 && (grad_im(x, y) >= grad_im(x, y - 1) && grad_im(x, y) >= grad_im(x, y + 1)))
                   
                out_non_max(x, y) = grad_im(x, y);
            end
        end
    end

    %Threshold hysteris
    thresh_low = low;
    thresh_high = high;
    for x = 2 : m - 1
        for y = 2 : n - 1
            if (out_non_max(x, y) < thresh_low)
                out_non_max(x,y) = 0;
            elseif (out_non_max(x,y) > thresh_high)
                out_non_max(x,y) = 255;
            elseif (out_non_max(x, y-1) > thresh_high || out_non_max(x+1, y-1) > thresh_high ||...
                out_non_max(x+1, y) > thresh_high || out_non_max(x+1, y+1) > thresh_high ||...
                out_non_max(x, y+1) > thresh_high || out_non_max(x-1, y+1) > thresh_high ||...
                out_non_max(x-1, y) > thresh_high|| out_non_max(x-1, y-1)> thresh_high)
                out_non_max(x,y) = 255;
            else
                out_non_max(x,y) = 0;
            end
        end
    end
    
    y = out_non_max;

end

