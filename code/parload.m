function [I,I2,pix2cm,fname]=parload(fileList)
Idata= load(fullfile(fileList.folder,fileList.name),'fname');
fname2=Idata.fname;
fname=fname2(1:end-4);
clear Idata
Idata= load(fullfile(fileList.folder,fileList.name),'I');
I=Idata.I;
clear Idata
Idata= load(fullfile(fileList.folder,fileList.name),'I2');
I2=Idata.I2;
clear Idata
Idata= load(fullfile(fileList.folder,fileList.name),'pix2cm');
pix2cm=Idata.pix2cm;
clear Idata
end

