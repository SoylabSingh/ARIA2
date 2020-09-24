function parwrite2file2(outputFolder2,fname,Errorcode)
  % problem file
  fid = fopen(fullfile(outputFolder2,'ProblematicImagedata.txt'), 'a+');
  warning(strcat('Error code for',fname,' is ',num2str(Errorcode)));
  fprintf(fid,'%s\n',strcat('Error code for',fname,' is ',num2str(Errorcode)));
end

