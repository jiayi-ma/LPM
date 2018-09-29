function [FP,FN] = plot_matches(I1, I2, X, Y, VFCIndex, CorrectIndex)
%   PLOT_MATCHES(I1, I2, X, Y, VFCINDEX, CORRECTINDEX)
%   considers correct indexes and indexes reserved by VFC, and then 
%   only plots the ture positive with blue lines, false positive with red
%   lines, false negative with green lines. For visibility, it plots at
%   most NUMPLOT (Default value is 50) matches proportionately.
%   
% Input:
%   I1, I2: Tow input images.
%
%   X, Y: Coordinates of intrest points of I1, I2 respectively.
%
%   VFCIndex: Indexes reserved by VFC.
%
%   CorrectIndex: Correct indexes.
%
%   See also:: VFC().

% Define the most matches to plot
NumPlot = 100000;
NumPlot = 100;
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

FP = FalsePos;
FN = FalseNeg;

NumPos = length(TruePos)+length(FalsePos)+length(FalseNeg);
if NumPos > NumPlot
    t_p = length(TruePos)/NumPos;
    n1 = round(t_p*NumPlot);
    f_p = length(FalsePos)/NumPos;
    n2 = round(f_p*NumPlot);
    f_n = length(FalseNeg)/NumPos;
    n3 = round(f_n*NumPlot);
else
    n1 = length(TruePos);
    n2 = length(FalsePos);
    n3 = length(FalseNeg);
end

per = randperm(length(TruePos));
TruePos = TruePos(per(1:n1));
per = randperm(length(FalsePos));
FalsePos = FalsePos(per(1:n2));
per = randperm(length(FalseNeg));
FalseNeg = FalseNeg(per(1:n3));

% FalsePos = [FalsePos,24];

interval = 20;
WhiteInterval = 255*ones(size(I1,1), interval, 3);
imagesc(cat(2, I1, WhiteInterval, I2)) ;
hold on ;

line([X(FalseNeg,1)'; Y(FalseNeg,1)'+size(I1,2)+interval], [X(FalseNeg,2)' ;  Y(FalseNeg,2)'],'linewidth', 1, 'color', 'g') ;%'g'

line([X(FalsePos,1)'; Y(FalsePos,1)'+size(I1,2)+interval], [X(FalsePos,2)' ;  Y(FalsePos,2)'],'linewidth', 1, 'color','r') ;%  [0.8,0.1,0]
line([X(TruePos,1)'; Y(TruePos,1)'+size(I1,2)+interval], [X(TruePos,2)' ;  Y(TruePos,2)'],'linewidth', 1, 'color','b' ) ;%[0,0.5,0.8]

axis equal ;axis off  ; 
hold off
drawnow;