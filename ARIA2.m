function ARIA2
%We developed a new software framework to capture various traits from a single image of seedling roots. 
% This framework is based on the mathematical notion of converting images of roots into an equivalent graph.
% This allows automated querying of multiple traits simply as graph operations.

% Developers : Zaki Jubery,Hsiang Sing Naik & Nigel Lee
% Copyright : Baskar Ganapathysubramanian
% Version 1 : July 14, 2013 by Hsiang Sing Naik & Nigel Lee
% Version 2: December 7, 2016 by Zaki Jubery
addpath('UserDefinedFunctions');
addpath('code')
addpath('code\FEDAngleFunctions')
% Define display window size
a=300;b=300;c=1100;d=700;
warning('off','all')
%  Create and then hide the UI as it is being constructed.
f = figure('Visible','off','Position',[a,b,c,d],'Toolbar', 'none');
tabgroup = uitabgroup('Parent', f);
set(gcf, 'Position', get(0, 'Screensize'));
startTab = uitab('Parent', tabgroup, 'Title', 'Software Info');
tab1 = uitab('Parent', tabgroup, 'Title', 'ImagePreprocessing');
tab3 = uitab('Parent', tabgroup, 'Title', 'DataExtraction');
%Initial tab
ARIAInfoPanel = uipanel('Parent', startTab,...
    'BackgroundColor', [.93, .84, .84],...
    'ShadowColor', [1, 0, 0, 1],...
    'Units', 'normalized',...
    'Position', [0.2, 0.5, 0.6, 0.4]);

uicontrol('Parent', ARIAInfoPanel,...
    'FontName', 'MS Sans Serif',...
    'Style', 'text',...
    'FontSize', 20,...
    'Units', 'normalized',...
    'Position', [0.12, 0.7, 0.8, 0.3],...
    'String', 'ARIA: Automated Root Image Analysis ');
infoString = sprintf('Software developed by Ganapathysubramanian group (ISU)\n\nLead Developer(s): Nigel Lee, Marcus Naik, Zaki Jubery \nGUI : Zaki Jubery');
uicontrol('Parent', ARIAInfoPanel,...
    'Units', 'normalized',...
    'Position', [0.015, 0.075, 0.8, 0.45],...
    'BackgroundColor', ARIAInfoPanel.BackgroundColor,...
    'Style', 'text',...
    'String', infoString,...
    'FontSize', 12,...
    'HorizontalAlignment', 'center');

uicontrol('Parent', startTab,...
    'Units', 'normalized',...
    'Position', [0.10, 0.3, 0.2, 0.1],...
    'BackgroundColor', ARIAInfoPanel.BackgroundColor,...
    'Style', 'pushbutton',...
    'String', 'ImageProcessing',...
    'FontSize', 16,...
    'Callback', @IPOnClick);

uicontrol('Parent', startTab,...
    'Units', 'normalized',...
    'Position', [0.70, 0.3, 0.2, 0.1],...
    'Style', 'pushbutton',...
    'String', 'DataExtraction',...
    'FontSize', 16,...
    'Callback', @DEOnClick);

    function IPOnClick(~, ~)
        tabgroup.SelectedTab = tab1;
    end
    function DEOnClick(~, ~)
        tabgroup.SelectedTab = tab3;
    end
% Assign the a name to appear in the window title.
f.Name = 'ARIA2';
% Move the window to the center of the screen.
movegui(f,'center')
% Make the window visible.
f.Visible = 'on';
% Remove number title
f.NumberTitle = 'off';
% Hide menu bar
f.MenuBar = 'none';
%% Construct GUI  components.
% Image Processing (tab1)
uicontrol('Parent', tab1,'Style','pushbutton',...
    'String','Image Location','Units', 'normalized','Position',[0.05,0.80,0.10,0.05],...
    'Callback',@datalocationbutton_Callback);
uicontrol('Parent', tab1,'Style','pushbutton',...
    'String','Output Location','Units', 'normalized','Position',[0.05,0.70,0.10,0.05],...
    'Callback',@outputlocationbutton_Callback);

uicontrol('Parent', tab1,'Style','text','String','Need to define starting point',...
    'Units', 'normalized','Position',[0.03,0.60,0.15,0.03]);
uicontrol('Parent', tab1,'Style','popupmenu',...
    'String',{'No','Yes'},...
    'Units', 'normalized','Position',[0.05,0.57,0.10,0.03],...
    'Callback',@popup_stptype_Callback);

uicontrol('Parent', tab1,'Style','text','String','Imaging Method',...
    'Units', 'normalized','Position',[0.03,0.50,0.15,0.03]);
uicontrol('Parent', tab1,'Style','popupmenu',...
    'String',{'Digital Camera','Scanner'},...
    'Units', 'normalized','Position',[0.05,0.47,0.10,0.03],...
    'Callback',@popup_imgmthd_Callback);

uicontrol('Parent', tab1,'Style','text','String','cm to pixel ratio',...
    'Units', 'normalized','Position',[0.05,0.40,0.10,0.03]);

uicontrol('Parent', tab1,'Style','edit','String','110',...
    'Units', 'normalized','Position',[0.05,0.37,0.10,0.03], 'Callback',@pix2cmbutton_Callback);

uicontrol('Parent', tab1,'Style','text','String',' Number of Processor',...
    'Units', 'normalized','Position',[0.05,0.30,0.10,0.03]);

uicontrol('Parent', tab1,'Style','edit','String','2',...
    'Units', 'normalized','Position',[0.05,0.27,0.10,0.03],'Callback',@nopbutton_Callback);

uicontrol('Parent', tab1,'Style','text','String','Segmentation Method',...
    'Units', 'normalized','Position',[0.05,0.20,0.10,0.03]);
uicontrol('Parent', tab1,'Style','popupmenu',...
    'String',{'Default','User Defined','k-means'},...
    'Units', 'normalized','Position',[0.05,0.17,0.10,0.03],...
    'Callback',@popup_segmethod_Callback);


uicontrol('Parent', tab1,'Style','pushbutton',...
    'String','Start','Units', 'normalized','Position',[0.05,0.05,0.10,0.03],...
    'Callback',@surfbutton_Callback);

% Data Extraction (tab3)
uicontrol('Parent', tab3,'Style','pushbutton',...
    'String','Image Data Location','Units', 'normalized','Position',[0.05,0.80,0.20,0.06],...
    'Callback',@datalocationanalbutton_Callback);
uicontrol('Parent', tab3,'Style','pushbutton',...
    'String','Output Location','Units', 'normalized','Position',[0.05,0.70,0.20,0.06],...
    'Callback',@outputlocationbutton2_Callback);

uicontrol('Parent', tab3,'Style','text','String',' Number of Processor',...
    'Units', 'normalized','Position',[0.05,0.43,0.20,0.06]);

uicontrol('Parent', tab3,'Style','edit','String','2',...
    'Units', 'normalized','Position',[0.05,0.40,0.20,0.06],'Callback',@nopbutton_Callback);

uicontrol('Parent', tab3,'Style','pushbutton',...
    'String','ExtractData','Units', 'normalized','Position',[0.05,0.15,0.20,0.06],...
    'Callback',@surfbuttonanal_Callback);
axes('Parent', tab1,'Units', 'normalized','Position',[0.2,0.1,0.75,0.75]);
peaks_data = peaks(35);
current_data = peaks_data;
surf(current_data);
axes('Parent', tab3,'Units', 'normalized','Position',[0.2,0.2,0.75,0.75]);
peaks_data = peaks(35);
current_data = peaks_data;
surf(current_data);

%% Default GUI inputs
% Image Processing
datasource='SampleData';
ouputsource='SampleData';
segmethod=0;
pix2cm='100';
nop='2';
stptype='0';
imgmthd='0';
% Trait Extraction
datasource2=fullfile('SampleData','ProcessedImages','Seg_image_data');
outputsource2='SampleData';

%% GUI supporting functions
    function popup_segmethod_Callback(source,~)
        % Determine the selected data set.
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current data to the selected data set.
        switch str{val}
            case 'Default' 
                segmethod = 0;
             case 'k-means' 
                segmethod = 2;
            case 'User Defined' 
                segmethod = 1;
        end
    end

    function popup_stptype_Callback(source,~)
        % Determine the selected data set.
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current data to the selected data set.
        switch str{val}
             case 'No' 
                stptype = 0;
            case 'Yes' 
                stptype = 1;
        end
    end

    function popup_imgmthd_Callback(source,~)
        % Determine the selected data set.
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current data to the selected data set.
        switch str{val}
             case 'Digital Camera' 
                imgmthd = 0;
            case 'Scanner' 
                imgmthd = 1;
        end
    end


    function pix2cmbutton_Callback(source,~)
        pix2cm=get(source, 'String');
    end
    function datalocationbutton_Callback(~,~)
        datasource = uigetdir();
    end
    function outputlocationbutton_Callback(~,~)
        ouputsource = uigetdir();
    end

    function outputlocationbutton2_Callback(~,~)
        outputsource2 = uigetdir();
    end


    function nopbutton_Callback(source,~)
        nop=get(source, 'String');
    end

    function datalocationanalbutton_Callback(~,~)
        datasource2 = uigetdir();
    end


%% Image Processing function
function surfbutton_Callback(~,~)
ARIA2_IP(datasource,ouputsource,segmethod,pix2cm,nop,stptype,imgmthd)
end

%% Trait Extraction
function surfbuttonanal_Callback(~,~)
ARIA2_TE(datasource2,outputsource2,nop)
end

end