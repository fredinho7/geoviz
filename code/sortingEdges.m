function sortingEdges(im)
    str=inputname(1);
    BW=im;
    BW=im2bw(BW);
    [B,L,N,A] = bwboundaries(BW);
    figure; imshow(BW), hold on;
    boundary1 = B{1};
   
    plot(boundary1(:,2),boundary1(:,1),'g','LineWidth',2); hold on;

    boundary2 = B{2};
    plot(boundary2(:,2),boundary2(:,1),'r','LineWidth',2);
    
    fName = strcat('textFilesEdges/',str,'1.txt'); %A file name
    fid = fopen(fName,'wt');
   
    %boundary har symmetriska replikerade värden på koordinaterna därför måste
    %vi dela längden av varje linje med 2.
    size(boundary1,1)/2;
   
    boundary1 = resampleVec(boundary1,5000);
    
    for k=1:size(boundary1,1)/2
        if boundary1(k,1)==1
            fprintf( fid, '%d,%d\n', boundary1(k,:));
            break
        end
      fprintf(fid, '%d,%d\n', boundary1(k,:));
    end
    
    fclose(fid);
    
    fName = strcat('textFilesEdges/',str,'2.txt'); %A file name
    fid = fopen(fName,'wt');
    size(boundary2,1)/2;
    
    boundary2 = resampleVec(boundary2,5000);
    
    for j=1:size(boundary2,1)/2
        if boundary2(j,1)==1
            fprintf( fid, '%d,%d\n', boundary2(j,:));
            break
        end
      fprintf( fid, '%d,%d\n', boundary2(j,:));
    end
    
    fclose(fid);
end
