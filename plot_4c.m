function plot_4c( I1,I2,X, Y, VFCIndex, CorrectIndex)
NumPlot = 500;
% NumPlot = 50;

n = size(X,1);
tmp=zeros(1, n);
tmp(VFCIndex) = 1;
tmp(CorrectIndex) = tmp(CorrectIndex)+1;
VFCCorrect = find(tmp == 2);
TruePos = VFCCorrect;   %Ture positive
tmp=zeros(1, n);
tmp(VFCIndex) = 1;
tmp(CorrectIndex) = tmp(CorrectIndex)-1;
FalsePos = find(tmp == 1); %False positive
tmp=zeros(1, n);
tmp(CorrectIndex) = 1;
tmp(VFCIndex) = tmp(VFCIndex)-1;
FalseNeg = find(tmp == 1); %False negative
all = 1:size(X,1);

TrueNeg = setdiff(all,FalsePos);
TrueNeg = setdiff(TrueNeg,TruePos);
TrueNeg = setdiff(TrueNeg,FalseNeg);

% NumPos = length(TruePos)+length(FalsePos)+length(FalseNeg);
% if NumPos > NumPlot
%     t_p = length(TruePos)/NumPos;
%     n1 = round(t_p*NumPlot);
%     f_p = length(FalsePos)/NumPos;
%     n2 = round(f_p*NumPlot);
%     f_n = length(FalseNeg)/NumPos;
%     n3 = round(f_n*NumPlot);
% else
%     n1 = length(TruePos);
%     n2 = length(FalsePos);
%     n3 = length(FalseNeg);
% end
% 
% per = randperm(length(TruePos));
% TruePos = TruePos(per(1:n1));
% per = randperm(length(FalsePos));
% FalsePos = FalsePos(per(1:n2));
% per = randperm(length(FalseNeg));
% FalseNeg = FalseNeg(per(1:n3));

k = 0;
siz = size(I1);
figure;



quiver(X(FalseNeg, 1), siz(1)-X(FalseNeg, 2), (Y(FalseNeg, 1)-X(FalseNeg, 1)), (-Y(FalseNeg, 2)+X(FalseNeg, 2)), k, 'g'), hold on
quiver(X(FalsePos, 1), siz(1)-X(FalsePos, 2), (Y(FalsePos, 1)-X(FalsePos, 1)), (-Y(FalsePos, 2)+X(FalsePos, 2)), k, 'r'), hold on
quiver(X(TrueNeg, 1), siz(1)-X(TrueNeg, 2), (Y(TrueNeg, 1)-X(TrueNeg, 1)), (-Y(TrueNeg, 2)+X(TrueNeg, 2)), k, 'k'), hold on
quiver(X(TruePos, 1), siz(1)-X(TruePos, 2), (Y(TruePos, 1)-X(TruePos, 1)), (-Y(TruePos, 2)+X(TruePos, 2)), k, 'b'), hold on


axis equal
axis([0 siz(2) 0 siz(1)]);




set(gca,'XTick',-2:1:-1)
set(gca,'YTick',-2:1:-1)


