%% Infiltration analysis 1

imageDir = 'C:\Users\antho\OneDrive\Desktop\Misc\20240221_Path_4a7-x31KO\Images';
%objDir = 'C:\Users\antho\OneDrive\Desktop\Misc\20240221_Path_4a7-x31KO\Images\ObjectSegm4';
%objDir = 'C:\Users\antho\OneDrive\Desktop\Misc\20240221_Path_4a7-x31KO\Images2\ObjectSegm';
objDir = 'C:\Users\antho\OneDrive\Desktop\Misc\20240221_Path_4a7-x31KO\Images3';



imDirList = dir(imageDir);
objDirList = dir(objDir);

output = {};
for i = [1:length(objDirList)]
    objName = objDirList(i).name;
    
    % Is file a tif file?
    isTIF = strfind(objName,'.tif');
    if isempty(isTIF)
        continue
    end

    % Load image
    objFile = [objDir,'\',objName];
    objIm = imread(objFile);

    backgroundArea = sum(find(objIm==3)); 
    lungArea = sum(find(objIm==2));
    infiltArea = sum(find(objIm==1));

    % Quantifiations
    infilt2lungRatio = infiltArea/lungArea;
    totLungArea = lungArea + infiltArea;
    infiltPercOfLung = (infiltArea/totLungArea)*100;
    
    % Append data
    outputLine = [{objName}, {infilt2lungRatio}, {totLungArea}, {infiltPercOfLung}];

    output = [output; outputLine];
end
   

clear backgroundArea i imageDir imDirList infilt2lungRatio infiltArea 
clear infiltPercOfLung isTIF lungArea objDir objDirList objFile objIm objName
clear outputLin totLungArea
















%% Generate QC images for histological analyses


%imageFile = 'C:\Users\antho\OneDrive\Desktop\Misc\20240221_Path_4a7-x31KO\Images\SF2255.tif';
%objFile = 'C:\Users\antho\OneDrive\Desktop\Misc\20240221_Path_4a7-x31KO\Images\ObjectSegm3\SF2255_Simple Segmentation.tif';

imageFile = 'C:\Users\antho\OneDrive\Desktop\Misc\20240221_Path_4a7-x31KO\Images\SF2253.tif';
objFile = 'C:\Users\antho\OneDrive\Desktop\Misc\20240221_Path_4a7-x31KO\Images\ObjectSegm3\SF2253_Simple Segmentation.tif';

addpath('C:\Program Files\MATLAB\R2022b\toolbox\shared\bfmatlab');


objIm = imread(objFile);
heIm = imread(imageFile);

% Prepares masks

bgMask = objIm;
bgMask(not(bgMask==3)) = 0;
bgMask(not(bgMask==0)) = 1;
bgMask = logical(bgMask);

infiltMask = objIm;
infiltMask(not(infiltMask==1)) = 0;
infiltMask(not(infiltMask==0)) = 1;


lungMask = objIm;
lungMask(not(lungMask==2)) = 0;
lungMask(not(lungMask==0)) = 1;

% 1. Generates background removed image

R = heIm(:,:,1);
G = heIm(:,:,2);
B = heIm(:,:,3);
R(bgMask) = 1;
G(bgMask) = 1;
B(bgMask) = 1;
outIm = cat(3,R,G,B);
imwrite(heIm,'original.png');
imwrite(outIm,'image1.png');

% 2. Generates lung mask & infiltration mask images

outIm2 = insertObjectMask(outIm, logical(infiltMask),...
    LineColor='white',...
    LineWidth=1,...
    Opacity=0.3,...
    Color='green');
%imshow(outIm2)
imwrite(outIm2,'image2.png');

outIm3 = insertObjectMask(outIm, logical(lungMask),...
    LineColor='white',...
    LineWidth=1,...
    Opacity=0.3,...
    Color='green');
imwrite(outIm3,'image3.png')











%% TMP: rename images


imageDir = 'C:\Users\antho\OneDrive\Desktop\Misc\20240221_Path_4a7-x31KO\Images';

dirList = dir(imageDir);
for i = [1:length(dirList)]
    objName = dirList(i).name;
    oldFile = [imageDir,'\',objName];

    isTIF = strfind(objName,'.tif');
    if isempty(isTIF)
        continue
    end

    objName = strsplit(objName, '_');
    objName = [objName{1},'.tif'];
    newFile = [imageDir,'\',objName];

    movefile(oldFile,newFile);
end




