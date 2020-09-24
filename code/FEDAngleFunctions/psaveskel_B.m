function psaveskel_B(fname,Iskel, skeBW,QCSkel,y,x,y1,x1)
imwrite(~Iskel,fullfile(QCSkel,strcat('skxy_',fname,'.jpg')))
% imwrite(skeBW,fullfile(QCSkel,'sk_',fname,'.jpg'))
save(fullfile(QCSkel,strcat('skxy_',fname,'.mat')),'Iskel')
% save(fullfile(QCSkel,'sk_',fname,'.mat'),'skeBW')
M=[y,x];
csvwrite(fullfile(QCSkel,strcat('skxy_',fname,'.csv')),M)
Mp=[y1,x1];
csvwrite(fullfile(QCSkel,strcat('primary_skxy_',fname,'.csv')),Mp)
end

