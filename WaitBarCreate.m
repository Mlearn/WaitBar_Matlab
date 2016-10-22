function h = WaitBarCreate(varargin)
Parameters = varargin;
N = length(varargin);
if mod(N,2)==0
    Para_Cell = reshape(Parameters,2,N/2);
end
ParentH = [];
BarType = 'Bar';
FillColor = 'green';
Alpha = 0.5;
BorderStyle = 'none';
BorderColor = 'r';
PosiSize = [0,0,1,1];
Steps = 100;
Percent = 0;
ChangeType = 'lr';
for i=1:N/2
    if strcmpi('Parent', Para_Cell{1,i})
        ParentH = Para_Cell{2,i};
    elseif strcmpi('BarType', Para_Cell{1,i})
        BarType = Para_Cell{2,i};
    elseif strcmpi('FillColor', Para_Cell{1,i})
        FillColor = Para_Cell{2,i};
    elseif strcmpi('BorderStyle', Para_Cell{1,i})
        BorderStyle = Para_Cell{2,i};
    elseif strcmpi('BorderColor', Para_Cell{1,i})
        BorderColor = Para_Cell{2,i};
    elseif strcmpi('Position', Para_Cell{1,i})
        PosiSize = Para_Cell{2,i};
    elseif strcmpi('Alpha', Para_Cell{1,i})
        Alpha = Para_Cell{2,i};
    elseif strcmpi('Steps', Para_Cell{1,i})
        Steps = Para_Cell{2,i};
    elseif strcmpi('Percent', Para_Cell{1,i})
        Percent = Para_Cell{2,i};
    elseif strcmpi('ChangeType', Para_Cell{1,i})
        ChangeType = Para_Cell{2,i};
    end
end
if isempty(ParentH)
    scrsz = get(0,'ScreenSize');
    if strcmpi('Bar',BarType)
        Position = [floor(scrsz(3)/2-200), floor(scrsz(4)/2-30), 400, 60];
        PosiSize = [0.01,0.3,0.98,0.4];
    elseif strcmpi('Pie',BarType)
        Position = [floor(scrsz(3)/2-100), floor(scrsz(4)/2-100), 200, 200];
        PosiSize = [0.1,0.1,0.8,0.8];
    end
    ParentH = figure('Name','WaitBar','NumberTitle','off','MenuBar','none','ToolBar','none','HandleVisibility','off', 'Position',Position);
end
h = WaitbarInit(ParentH, BarType, PosiSize, Steps, FillColor, Alpha, BorderStyle, BorderColor, Percent, ChangeType);
end

function WaitBarStruct =  WaitbarInit(ParentHandle, BarType, PosiSize, Steps, FillColor, Alpha, BorderStyle, BorderColor, Percent, ChangeType)
WaitBarStruct = [];
WaitBarStruct.Percent = Percent;
WaitBarStruct.BarType = BarType;
WaitBarStruct.FillColor = FillColor;
WaitBarStruct.Alpha = Alpha;
WaitBarStruct.BorderStyle = BorderStyle;
WaitBarStruct.BorderColor = BorderColor;
WaitBarStruct.Steps = Steps;
WaitBarStruct.Position = PosiSize;
BCorners = []; vv = [];
WaitBarStruct.axes = axes('Parent',ParentHandle, 'Position',PosiSize,'Box','off', 'XLim',[0 1],'YLim',[0 1],'XTick',[],'YTick',[],'Visible','off');
if strcmpi('Bar',BarType)
    if strcmpi('lr', ChangeType)
    BCorners = [linspace(0,1,Steps+1)',zeros(Steps+1,1);linspace(0,1,Steps+1)',ones(Steps+1,1)];
    elseif strcmpi('rl', ChangeType)
        BCorners = [linspace(1,0,Steps+1)',zeros(Steps+1,1);linspace(1,0,Steps+1)',ones(Steps+1,1)];
    elseif strcmpi('bt', ChangeType)
        BCorners = [zeros(Steps+1,1),linspace(0,1,Steps+1)';ones(Steps+1,1),linspace(0,1,Steps+1)'];
    elseif strcmpi('tb', ChangeType)
        BCorners = [zeros(Steps+1,1),linspace(1,0,Steps+1)';ones(Steps+1,1),linspace(1,0,Steps+1)'];
    end
    p = floor(WaitBarStruct.Percent*Steps)+1;
    vv = [1,p,Steps+1+p,Steps+2];
    if ~strcmpi('none',BorderStyle)
        WaitBarStruct.Border = line([0,1,1,0,0],[0,0,1,1,0], 'Parent',WaitBarStruct.axes, 'LineStyle',BorderStyle, 'Color',BorderColor);
        set(WaitBarStruct.axes,'XTick',[],'YTick',[],'Visible','off');
    end
end
if strcmpi('Pie',BarType)
    set(WaitBarStruct.axes,'DataAspectRatio',[1,1,1]);
    WaitBarStruct.RealSteps = 500;
    R = 0.5;
    if strcmpi('lr', ChangeType)
        x = R+R*sin(linspace(0,1,WaitBarStruct.RealSteps+1)*2*pi);
        y = R+R*cos(linspace(0,1,WaitBarStruct.RealSteps+1)*2*pi);
    elseif strcmpi('rl', ChangeType)
        x = R+R*sin(linspace(1,0,WaitBarStruct.RealSteps+1)*2*pi);
        y = R+R*cos(linspace(1,0,WaitBarStruct.RealSteps+1)*2*pi);
    end
    BCorners = [R,R;x',y'];
    p = floor(floor(WaitBarStruct.Percent*Steps)*(WaitBarStruct.RealSteps/Steps))+1;
    vv = [1,2:p+1,1];
    if ~strcmpi('none',BorderStyle)
        WaitBarStruct.Border = line(x,y,'Parent',WaitBarStruct.axes,'LineStyle',BorderStyle, 'Color',BorderColor);
        set(WaitBarStruct.axes,'DataAspectRatio',[1,1,1],'XTick',[],'YTick',[],'Visible','off');
    end
end
WaitBarStruct.BCorners = BCorners;

WaitBarStruct.Patch = patch('Parent',WaitBarStruct.axes,'vertices', WaitBarStruct.BCorners, 'faces',vv, 'FaceColor', FillColor, 'FaceAlpha',Alpha, 'LineStyle','none');
drawnow;
end
