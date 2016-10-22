function WaitBarUpdate(varargin)
Parameters = varargin;
N = length(varargin);
if mod(N,2)==1
    wH = Parameters{1};
    Para_Cell = reshape(Parameters(2:end),2,(N-1)/2);
end
Percent = wH.Percent;
FillColor = wH.FillColor;
Alpha = wH.Alpha;
BorderStyle = wH.BorderStyle;
BorderColor = wH.BorderColor;
for i=1:N/2
    if strcmpi('Percent', Para_Cell{1,i})
        Percent = Para_Cell{2,i};
    elseif strcmpi('Color', Para_Cell{1,i})
        FillColor = Para_Cell{2,i};
    elseif strcmpi('BorderStyle', Para_Cell{1,i})
        BorderStyle = Para_Cell{2,i};
    elseif strcmpi('BorderColor', Para_Cell{1,i})
        BorderColor = Para_Cell{2,i};
    elseif strcmpi('Alpha', Para_Cell{1,i})
        Alpha = Para_Cell{2,i};
    end
end
WaitbarRefresh(wH, Percent, FillColor, Alpha, BorderStyle, BorderColor);
end

function WaitbarRefresh(WaitBarStruct, Percent, FillColor, Alpha, BorderStyle, BorderColor)
WaitBarStruct.Percent = Percent;
WaitBarStruct.FillColor = FillColor;
WaitBarStruct.BorderStyle = BorderStyle;
WaitBarStruct.BorderColor = BorderColor;
BarType = WaitBarStruct.BarType;
Steps = WaitBarStruct.Steps;
vv = [];
if strcmpi('Bar',BarType)% 画长方形进度条
    p = floor(WaitBarStruct.Percent*Steps)+1;
    vv = [1,p,Steps+1+p,Steps+2];
end
if strcmpi('Pie',BarType)% 画圆形进度条
    RealSteps = WaitBarStruct.RealSteps;
    p = floor(floor(Percent*Steps)*(RealSteps/Steps))+1;
    vv = [1,2:p+1,1];
end
set(WaitBarStruct.Patch,'faces',vv, 'FaceColor', FillColor,'FaceAlpha',Alpha, 'LineStyle','none');
drawnow;
end