
%plot1 = heatmap(reshape(sol(500,:,:,1),[nx,ny]))
%for k = 2:nt
%     plot1 = heatmap(reshape(sol(k,:,:,1),[nx,ny]))
%     pause(.1)
%end
%2000

%M = sol(4000,:,:,1)*287*300;
%m = reshape(M,[nx,ny]);

%plot1 = heatmap(rot90(fliplr(m),-1),'Colormap',parula);





heatmap(rot90(fliplr(reshape(sol(10000,:,:,1),[nx,ny])), -1),'Colormap',parula)
set(gcf,'position',[600,600,1000,500])
title("Density Accross a 2D Mountain Range")

heatmap(rot90(fliplr(reshape(sol(10000,:,:,2),[nx,ny])), -1),'Colormap',parula)
set(gcf,'position',[600,600,1000,500])
title("Horizontal Momentum Accross a 2D Mountain Range")


heatmap(rot90(fliplr(reshape(sol(10000,:,:,3),[nx,ny])), -1),'Colormap',parula)
set(gcf,'position',[600,600,1000,500])
title("Vertical Momentum Accross a 2D Mountain Range")
