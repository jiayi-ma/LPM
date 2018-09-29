%%  LPM_v2 ,i.e. LPM version 2, 
% using  Multi_scale  and  Consensus of Neighborhood Topology
clear 
close all;
initialization;  %run it only at the first time
%% parameters setting
lambda1   = 0.8;   lambda2   = 0.5;   
numNeigh1 = 6;     numNeigh2 = 6; 
tau1      = 0.2;   tau2      = 0.2;   
%% input image pair with putative matches or without putative matches

% % % remote sensing data

fn_l = '1.bmp';
fn_r = '2.bmp';
Ia = imread(fn_l);
Ib = imread(fn_r);
load  putative_match.mat;

% % % medical retina data

% fn_l = 'retina_a.jpg';
% fn_r = 'retina_b.jpg';
% Ia = imread(fn_l);
% Ib = imread(fn_r);
% load  retina_putative_match.mat;

% % % no initial correspondence

% fn_l = '1.bmp';
% fn_r = '2.bmp';
% Ia = imread(fn_l);
% Ib = imread(fn_r);
% Ia = imresize(Ia, [size(Ib,1), size(Ib,2)]);
% if size(Ia,3) == 1
%     Ia = repmat(Ia,[1,1,3]);
%     Ib = repmat(Ib,[1,1,3]);
% end
% SiftThreshold = 1.5; % no smaller than 1
% [X, Y] = sift_match(Ia, Ib, SiftThreshold);

%% 
if size(Ia,3)==1
    Ia = repmat(Ia,[1,1,3]);
end
if size(Ib,3)==1
    Ib = repmat(Ib,[1,1,3]);
end

[wa,ha,~] = size(Ia);
[wb,hb,~] = size(Ib);
maxw = max(wa,wb);  maxh = max(ha,hb);
Ib(wb+1:maxw, :,:) = 0;
Ia(wa+1:maxw, :,:) = 0;
%%
tic;
x1 = X; y1 = Y;
[numx1,~] = size(x1);
p1 = ones(1,numx1);
Xt = X';Yt = Y';
vec=Yt-Xt;
d2=vec(1,:).^2+vec(2,:).^2;

%%  iteration 1
% % % constructe K-NN by kdtree
kdtreeX = vl_kdtreebuild(Xt);
kdtreeY = vl_kdtreebuild(Yt);  
[neighborX, ~] = vl_kdtreequery(kdtreeX, Xt, Xt, 'NumNeighbors', numNeigh1+3) ;
[neighborY, ~] = vl_kdtreequery(kdtreeY, Yt, Yt, 'NumNeighbors', numNeigh1+3) ;

% % % calculate the locality costs C and return binary vector p
[p2, C] = LPM_cosF(neighborX, neighborY, lambda1, vec, d2, tau1, numNeigh1);

%%  iteration 2
idx = find( p2 == 1 );
if length(idx)>= numNeigh2+4
kdtreeX = vl_kdtreebuild(Xt( :, idx ));
kdtreeY = vl_kdtreebuild(Yt( :, idx ));
[neighborX, ~] = vl_kdtreequery(kdtreeX, Xt(:,idx), Xt, 'NumNeighbors', numNeigh2+3) ;
[neighborY, ~] = vl_kdtreequery(kdtreeY, Yt(:,idx), Yt, 'NumNeighbors', numNeigh2+3) ;
neighborX = idx(neighborX);
neighborY = idx(neighborY);
[p2, C] = LPM_cosF(neighborX, neighborY, lambda2, vec, d2, tau2, numNeigh2);
end
toc
%% 
ind = find(p2 == 1);
if ~exist('CorrectIndex'), CorrectIndex = ind; end
[FP,FN] = plot_matches(Ia, Ib, X, Y, ind, CorrectIndex);
plot_4c(Ia, Ib, X, Y, ind, CorrectIndex);


