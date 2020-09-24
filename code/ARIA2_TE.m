function ARIA2_TE(datasource2,outputsource2,nop)
% This function extract traits from the segmented images

% datasource2: location of segmented image data
% outputsource2: location to save the extracted traits
% nop: number of processor
% all inputs are in string. 

% Developers : Zaki Jubery,Hsiang Sing Naik & Nigel Lee
% Copyright : Baskar Ganapathysubramanian
% Version 1 : July 14, 2013 by Hsiang Sing Naik & Nigel Lee
% Version 2: December 7, 2016 by Zaki Jubery
addpath('UserDefinedFunctions');
addpath('FEDAngleFunctions');
%% Trait Extraction Function
        warning off;
        % Force the variable is to be number
        if isstr(nop)==1
            nop=str2num(nop);
        end
        % Data directory
        inputFolder2=datasource2;
        % Output directory
        outputFolder2=fullfile(outputsource2,'ExtractedTraits');
        mkdir(outputFolder2);
        % Prepare output folders
        dirinfo = dir(inputFolder2);
        fileList=dirinfo;
        logfilename = ['log_TraitExtract', strrep(datestr(clock), ':' , '-' ) ,'.txt'] ;
        diary(fullfile(outputFolder2,logfilename));
        % Create folder to store QC images
        QCimage2=fullfile(outputFolder2,'QC_image');
        mkdir(QCimage2);
        
        % Directionality check
        QCdirection=strcat(outputFolder2,'\Angles\');
        mkdir(QCdirection);
        % Skelenotization check
        QCSkel=strcat(outputFolder2,'\Skeleton\');
        mkdir(QCSkel);
       % Shape check
        QCShape1=strcat(outputFolder2,'\Shape_ConHull\');
        mkdir(QCShape1);
        QCShape2=strcat(outputFolder2,'\Shape_Boundary\');
        mkdir(QCShape2);
        % Prepare data for parallel processing
        count=1;
        imagetypelist= {'.mat'};
        fileList2=fileList;
        for K=1:length(fileList)
            if endsWith(fileList(K).name,imagetypelist)
                fileList2(count)=fileList(K);
                count=count+1;
            end
        end
        % Prepare message box to show the progress
        t = datetime('now');
        DateString = datestr(t);
        mh=msgbox({'Extracting Traits...Please Wait ...'; strcat('Total number of images is ...',num2str(count-1));'Estimated processing time per image is between 1 to 3 mintues'; strcat('Expected completion time is between ...', num2str((count-1)/nop),'  to  ', num2str(3*(count-1)/nop),'  mintues'); strcat('Processing started at ... ', DateString)} );
        th = findall(mh, 'Type', 'Text');                   
        th.FontSize = 12;                                   
        deltaWidth = sum(th.Extent([1,3]))-mh.Position(3) + th.Extent(1);
        deltaHeight = sum(th.Extent([2,4]))-mh.Position(4) + 10;
        mh.Position([3,4]) = mh.Position([3,4]) + [deltaWidth, deltaHeight];
        mh.Resize = 'on'; 
        pause(0.01)
         parpool('local',nop);
        nNumIterations=count-1;
        strWindowTitle='Extracting Traits... Please Wait ...  ';
        nProgressStepSize=nop;
        nWidth=700;
        nHeight=75;
         ppm = ParforProgMon(strWindowTitle, nNumIterations, nProgressStepSize, nWidth, nHeight);
         parfor K=1:count-1
             try
                Errorcode=0;
                try
                    [I,I2,pix2cm,fname]=parload(fileList2(K));
                catch
                    Errorcode=1;
                    I=[]
                    I2=[]
                    pix2cm=[]
                    fname=fileList2(K).name
                end
                % Force the variable is to be number
                if isstr(pix2cm)==1
                    pix2cm=str2num(pix2cm);
                end
                disp(strcat('Currently processing ',num2str(K),' of ',num2str(count-1),' ,image name:',fname));
                % Analyze the root
                [TotalRootLength,Primaryrootlength,sumSecondaryLength,meanSecondaryLength,lengthSLbyPL,MedianR, MaximumR,LengthDistribution, Perimeter, Diameter, Volume, SurfaceArea,TRLUpper, TRLLower, ...
                    CM, CMT, CMM, CMB, CP, CPT, CPM, CPB,ConvexArea, Depth, Width, NetworkArea,NofSR,NofSR2,NofSR3,Root,skeBW,sroot,x,y,path,...
                    Area,TRAUpper, TRALower,RatY] = ExtractTraits(I,pix2cm,QCimage2,fname,I2);
                Errorcode=2;
                
                
             % save skeletonized image
                %n=size(I);
                Iskel=zeros(size(I));
                for i=1:length(x);Iskel(y(i),x(i))=1;end;

                xpt=zeros(length(path),1);
                ypt=zeros(length(path),1);
                for n = 1 : length(path)
                    xpt(n) = x(path(n));
                    ypt(n) = y(path(n));
                end
                psaveskel_B(fname,Iskel,skeBW,QCSkel,y,x,ypt,xpt);

                % Parameter for sanity check
                Area2check=bwarea(I)/(pix2cm)^2;
                Image2check=Area/Area2check;
                
                % Root directions
                [N1,N2,N3,edges]=DirectionalityMeasurementv2(QCdirection,fname,skeBW,sroot,x,y,path);                
%                 Errorcode=3;
                % FED on Convexhull
                 [ rsdC ] = chull_EFD( QCShape1,fname,Root);
%                 Errorcode=4;
                % FED on boundary and area of rhizosphere
                 [r_area,rsdB] = rhizosphere( QCShape2,fname,Root );
                 r_area=r_area/pix2cm;
%                 Errorcode=5;
                % Store the traits
                WTa=[{fname},TotalRootLength,Primaryrootlength,sumSecondaryLength,meanSecondaryLength,lengthSLbyPL,MedianR, MaximumR,LengthDistribution, Perimeter, Diameter, Volume, SurfaceArea,TRLUpper, TRLLower, ...
                    CM, CMT, CMM, CMB, CP, CPT, CPM, CPB,ConvexArea, Depth, Width, NetworkArea,NofSR,NofSR2,NofSR3,Area,TRAUpper, TRALower,Image2check];
                Errorcode=6;
                DTa=[{fname},N1 N2 N3];
                 CHTa=[{fname},reshape(rsdC,1,400)];
                 BTa=[{fname},reshape(rsdB,1,400)];
                Errorcode=7;
                All{K}=WTa;
                All_DTa{K}=DTa;
                 All_CHTa{K}=CHTa;
                 All_BTa{K}=BTa;
                Errorcode=8;
                YN=[{fname},RatY'];
                All_YN{K}=YN;
                 ppm.increment();
            catch
                parwrite2file2(outputFolder2,fname,Errorcode)
                All{K}=[];
                All_YN{K}=[];
                All_DTa{K}=[];
                All_CHTa{K}=[];
                All_BTa{K}=[];
                
            end
        end
        %Save as mat file
        save (fullfile(outputFolder2,'ExtractedTraits.mat'));
        
        msgbox({'Saving Extracted Traits'});
        %Write to excel file
        outfile2=fullfile(outputFolder2,'ExtractedTraits.xlsx');
        AllTraits=[];
        for pp=1:count-1
            if ~isempty(All{pp})
                L1=cell2table(All{pp},'VariableNames',{'imagename','TotalRootLength','Primaryrootlength','sumSecondaryLength','meanSecondaryLength','lengthSLbyPL','MedianR', 'MaximumR',...
                    'LengthDistribution', 'Perimeter', 'Diameter', 'Volume',...
                    'SurfaceArea','TRLUpper', 'TRLLower', ...
                    'CM', 'CMT', 'CMM', 'CMB', 'CP', 'CPT', 'CPM', 'CPB','ConvexArea', 'Depth', 'Width', 'NetworkArea','NofSR','NofSR2','NofSR3','Area','TRAUpper','TRALower','ImageFlag'});
                AllTraits=[ AllTraits;L1];
            end
        end
        writetable(AllTraits, ...
            outfile2,'Sheet',1,'WriteVariableNames',true);
        outfile3=fullfile(outputFolder2,'no_Root_at_different_depth_in_pixels_Y.xlsx');
        YN_all=[];
        for i=1:count-1
            if ~isempty(All_YN{i})
                YN_all=[YN_all;cell2table(All_YN{i},'VariableNames',{'imagename','n_Root_at_Y'})];
            end
        end
        writetable (YN_all, ...
            outfile3,'Sheet',1,'WriteVariableNames',true);    
        
         
         outfile4=strcat(outputFolder2,'\','Fourier_Shape_Descriptors_for_ConvexHull.xlsx');
         outfile5=strcat(outputFolder2,'\','Fourier_Shape_Descriptors_for_Boundary.xlsx');
        outfile6=strcat(outputFolder2,'\','Angles_0_90_bin_2_degree.xlsx');

        DTa_all=[];
         CHTa_all=[];
         BTa_all=[];
        for i=1:count-1
            if ~isempty(All_DTa{i})
            L2=cell2table(All_DTa{i},'VariableNames',{'imagename','near_node','root_segment','root_tip'});
            DTa_all=[DTa_all;L2];
            end
            if ~isempty(All_CHTa{i})
             CHTa_all=[CHTa_all;cell2table(All_CHTa{i},'VariableNames',{'imagename','EFD'})];
            end
            if ~isempty(All_BTa{i})
             BTa_all=[BTa_all;cell2table(All_BTa{i},'VariableNames',{'imagename','EFD'})];
            end
        end

        writetable(DTa_all, ...
            outfile6,'Sheet',1,'WriteVariableNames',true);
         writetable(CHTa_all, ...
             outfile4,'Sheet',1,'WriteVariableNames',true);
         writetable(BTa_all, ...
             outfile5,'Sheet',1,'WriteVariableNames',true);
        
        poolobj = gcp('nocreate');
        delete(poolobj);
        close all;
        msgbox({'Trait Extraction' 'Completed'});
end