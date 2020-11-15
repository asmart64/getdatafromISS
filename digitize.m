close all;clearvars
% User Parameters:
picture_filename='italia_nov2020_short.png'; % filename of the image containing the plot
area_min=3; area_max=55; % The connected regions marking the top of each bar can have minimum and max number of pixels
                         % these limits can be set by looking at the
                         % corrispondent histogram ('Size distribution')
debug_run=false; % if true it will show some images useful for troubleshooting
fact_correction=1.0000; % correction factor for the conversion from pixell coords to actual coords
table_filename = 'Italia_nov2020_short.csv';
x = imread(picture_filename);
imshow(x)
[yl xl nchan]=size(x);
title('Raw Image')

disp('click on the bottom y-axis  point ')
h_y1 = drawpoint; h_y1.Label = 'y1';
py1=h_y1.Position; py1=py1(2);
y1_value = input('input the corresponding y value: ');

disp('click on the top y-axis point')
h_y2 = drawpoint; h_y2.Label = 'y2';
py2=h_y2.Position; py2=py2(2);
y2_value = input('input the second y value: ');
% conversion law: y= y1_value + (yp-py1)*(y2_value-y1_value)/(py2-py1)

disp('click on the leftmost point on the x axis')
h_x1 = drawpoint; h_x1.Label = 'x1';
px1=h_x1.Position; px1=px1(1)
x1_value = input('input the x leftmost date value (yyyy-mm-dd): ','s');
x1_value = datetime(x1_value,'InputFormat','yyyy-MM-dd');
disp('click on the rightmost  point on the x axis')
h_x2 = drawpoint; h_x2.Label = 'x2';
px2=h_x2.Position; px2=px2(1)
x2_value = input('input the rightmost x value (yyyy-mm-dd): ','s');
x2_value = datetime(x2_value,'InputFormat','yyyy-MM-dd');
% conversion law: x= x1_value + (xp-px1)*(x2_value-x1_value)/(px2-px1)
disp('Now draw a rectangle around the points excluding labels and axes')
roi=drawrectangle;
% roi.position=[xmin, ymin, width, height]
xmin=roi.Position(1);
xmax=xmin+roi.Position(3);
ymin=roi.Position(2);
ymax=ymin+roi.Position(4);





% The dataset is targeted through a color-mask
% defined by using colorThresholder (produces createMask function)
[BW,maskedRGBImage] = createMask_blu_bars2(x);
kern=zeros(3);
kern(1,2)=1; kern(3,2)=-1;

x_dots=conv2(double(255* ~BW),kern);



x_dots=abs(x_dots(ymin:ymax,xmin:xmax));
if (debug_run)
    imshow(x_dots)
end


%label connected regions
L = bwlabel(x_dots);
if (debug_run)
    figure
    imshow(L,[])
    colormap jet
    %pixval
    title('Connected Regions')
end


%feature extraction - size distribution (area, pixels)
stats = regionprops(L);
A = [stats.Area];

figure
histogram(A)
xlabel('Area (pixels)')
ylabel Popularity
title('Size Distribution')

P=cat(1,stats.Centroid)
%P = [stats.Centroid];
Pm=P(find(A>area_min & A<area_max),:)';
n_points=length(Pm);
%Pm=reshape(P, [2,n_points]);
% the bottom part of the bars is still part of the dot set.
% some data point refers to same x
% Let's clean up the data
miny=max(Pm(2,:)); % pixel coords increase going downwards
Pms2=Pm(:,Pm(2,:)<miny-1);
[sorted_x,sort_index] = sort(Pms2(1,:));
n_points=length(Pms2);
jn=0;
k=1;
while (k<n_points)

    if (abs(sorted_x(k)-sorted_x(k+1))<=1)
        jn=jn+1;
        % pick the point with higher y (smaller pixel coord)
        Pms(1,jn)=sorted_x(k); Pms(2,jn)=min(Pms2(2,sort_index(k)),Pms2(2,sort_index(k+1)));
        k=k+2;
    else
        jn=jn+1;
        Pms(:,jn)=Pms2(:,sort_index(k));
        k=k+1
    end   
end


% Pms is the array with the coords of the dots
if (debug_run)
    figure
    plot(Pms(1,:),Pms(2,:),'o')
end
Pms(1,:)=Pms(1,:)+xmin;
Pms(2,:)=Pms(2,:)+ymin;
if (debug_run)
    figure;imshow(x)
    hold on
    plot(Pms(1,:),Pms(2,:),'r*')
    hold off
end

% Conversion to true coordinates
y_correction=+1;
x_correction=0;

xt= x1_value + (Pms(1,:)-px1)*(x2_value-x1_value)/(px2-px1);
yt= y1_value + (Pms(2,:)-py1)*(y2_value-y1_value)/(py2-py1)*fact_correction;

figure; plot(xt,yt,'bo')
fout=table_filename;
date=(datetime(xt+x_correction,'Format','yyyy-MM-dd'))'; corrected_pos=floor(yt'+y_correction);
td=table(date,corrected_pos);
writetable(td,fout)



