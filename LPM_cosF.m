function [p,C]=LPM_cosF(neighborX,neighborY,lambda,vec,d2,tau,K)
%% *************************************
% Multi-scale LPM.  
% 3 scale: K1= K-4£» K2=K-2£» K3= K.
% C=sum(ci/Ki).
% lambda is ranged from  0 to 1
%% **************************************
[~, L] = size(neighborX);
C = 0;
if K<4
    Error(' K must not less than 4£¬ so that the multi-scale not less than [2 4 6]')
end
vx = vec(1, :); vy = vec(2, :);
Km = K+2 : -2 : K-2;%:K-4;
M  = length(Km);

for KK = Km
neighborX = neighborX(2:KK+1, :);   
neighborY = neighborY(2:KK+1, :);
neighborIndex = [neighborX; neighborY];
index = sort(neighborIndex);
temp1 = diff(index);
temp2 = (temp1 == zeros(size(temp1, 1), size(temp1, 2)));
ni = sum(temp2); %  the number of common elements in the K-NN
d2i = d2(index);
vxi = vx(index); vyi = vy(index);
%% cost calculation
%**** 
c1 = KK-ni;
%*****
cos_sita = (vxi.*repmat(vx,size(vxi,1),1) + vyi.*repmat(vy,size(vyi,1),1)) ./ sqrt(d2i.*repmat(d2,size(d2i,1),1));
ratio = min(d2i, repmat(d2,size(d2i,1),1)) ./ max(d2i, repmat(d2,size(d2i,1),1));
c2i = cos_sita.*ratio < tau.*ones(size(ratio, 1), size(ratio, 2));
c2i0 = c2i(1:end-1, :).*temp2;
c2 = sum(c2i0);

C = C+ (c1+c2)/KK;%
end
p = (C./M) <= lambda.*ones(1,L);%C/M

