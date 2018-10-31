classdef WaitBar < handle
    properties
        parent
        bartype
        fillcolor
        borderstyle
        bordercolor
        position
        alpha
        steps
        percent
        direction
    end
    properties(Hidden)
        Axes
        Border
        RealSteps
        BCorners
        Patch
    end
    methods
        function obj = WaitBar(varargin)
            % reference: https://cloud.tencent.com/developer/ask/116509
            options = struct(...
                'parent',       [],...
                'bartype',      'Bar',...
                'fillcolor',    'green',...
                'borderstyle',  'none',...
                'bordercolor',  'r',...
                'position',     [0,0,1,1],...
                'alpha',        0.5,...
                'steps',        100,...
                'percent',      0,...
                'direction',    'lr');
            optionNames = fieldnames(options);
            nArgs = length(varargin);
            if round(nArgs/2)~=nArgs/2
                error('WaitBarCreate needs propertyName/propertyValue pairs')
            end
            for pair = reshape(varargin,2,[]) %# pair is {propName;propValue}
                inpName = lower(pair{1}); %# make case insensitive
                if any(strcmpi(inpName,optionNames))
                    %# overwrite options. If you want you can test for the right class here
                    %# Also, if you find out that there is an option you keep getting wrong,
                    %# you can use "if strcmp(inpName,'problemOption'),testMore,end"-statements
                    options.(inpName) = pair{2};
                else
                    error('%s is not a recognized parameter name',inpName)
                end
            end
            fdnames = fieldnames(options);
            for i = 1:length(fdnames)
                fdname = fdnames{i};
                obj.(fdname) = options.(fdname);
            end
            
            if any(strcmpi(obj.bartype,{'Bar','Pie'})) && isempty(obj.parent)
                scrsz = get(0,'ScreenSize');
                if strcmpi('Bar',obj.bartype)
                    Pos = [floor(scrsz(3)/2-200), floor(scrsz(4)/2-30), 400, 60];
                    obj.position = [0.01,0.3,0.98,0.4];
                elseif strcmpi('Pie',obj.bartype)
                    Pos = [floor(scrsz(3)/2-100), floor(scrsz(4)/2-100), 200, 200];
                    obj.position = [0.1,0.1,0.8,0.8];
                end
                obj.parent = figure('Name','WaitBar','NumberTitle','off','MenuBar','none','ToolBar','none','HandleVisibility','off', 'position',Pos);
            end
            obj.FigureInit();
            
        end
        
        function FigureInit(obj)
            Bartype = obj.bartype;
            Steps = obj.steps;
            borderStyle = obj.borderstyle;
            borderColor = obj.bordercolor;
            fillColor = obj.fillcolor;
            Direction = obj.direction;
            Alpha = obj.alpha;
            obj.BCorners = []; vv = [];
            obj.Axes = axes('parent',obj.parent, 'position',obj.position,'Box','off', 'XLim',[0 1],'YLim',[0 1],'XTick',[],'YTick',[],'Visible','off');
            if strcmpi('Bar',Bartype)
                if strcmpi('lr', Direction)
                    obj.BCorners = [linspace(0,1,Steps+1)',zeros(Steps+1,1);linspace(0,1,Steps+1)',ones(Steps+1,1)];
                elseif strcmpi('rl', Direction)
                    obj.BCorners = [linspace(1,0,Steps+1)',zeros(Steps+1,1);linspace(1,0,Steps+1)',ones(Steps+1,1)];
                elseif strcmpi('bt', Direction)
                    obj.BCorners = [zeros(Steps+1,1),linspace(0,1,Steps+1)';ones(Steps+1,1),linspace(0,1,Steps+1)'];
                elseif strcmpi('tb', Direction)
                    obj.BCorners = [zeros(Steps+1,1),linspace(1,0,Steps+1)';ones(Steps+1,1),linspace(1,0,Steps+1)'];
                end
                p = floor(obj.percent*Steps)+1;
                vv = [1,p,Steps+1+p,Steps+2];
                if ~strcmpi('none',borderStyle)
                    obj.Border = line([0,1,1,0,0],[0,0,1,1,0], 'parent',obj.Axes, 'LineStyle',borderStyle, 'Color',borderColor);
                    set(obj.Axes,'XTick',[],'YTick',[],'Visible','off');
                end
            end
            if strcmpi('Pie',Bartype)
                set(obj.Axes,'DataAspectRatio',[1,1,1]);
                obj.RealSteps = 500;
                R = 0.5;
                if strcmpi('lr', Direction)
                    x = R+R*sin(linspace(0,1,obj.RealSteps+1)*2*pi);
                    y = R+R*cos(linspace(0,1,obj.RealSteps+1)*2*pi);
                elseif strcmpi('rl', Direction)
                    x = R+R*sin(linspace(1,0,obj.RealSteps+1)*2*pi);
                    y = R+R*cos(linspace(1,0,obj.RealSteps+1)*2*pi);
                end
                obj.BCorners = [R,R;x',y'];
                p = floor(floor(obj.percent*Steps)*(obj.RealSteps/Steps))+1;
                vv = [1,2:p+1,1];
                if ~strcmpi('none',borderStyle)
                    obj.Border = line(x,y,'parent',obj.Axes,'LineStyle',borderStyle, 'Color',borderColor);
                    set(obj.Axes,'DataAspectRatio',[1,1,1],'XTick',[],'YTick',[],'Visible','off');
                end
            end
            
            obj.Patch = patch('parent',obj.Axes,'vertices', obj.BCorners, 'faces',vv, 'FaceColor', fillColor, 'FaceAlpha',Alpha, 'LineStyle','none');
            drawnow;
        end
        
        function Update(obj,varargin)
            options = struct(...
                'fillcolor',    'green',...
                'borderstyle',  'none',...
                'bordercolor',  'r',...
                'alpha',        0.5,...
                'percent',      0);
            optionNames = fieldnames(options);
            nArgs = length(varargin);
            if round(nArgs/2)~=nArgs/2
                error('WaitBarCreate needs propertyName/propertyValue pairs')
            end
            for pair = reshape(varargin,2,[]) %# pair is {propName;propValue}
                inpName = lower(pair{1}); %# make case insensitive
                if any(strcmpi(inpName,optionNames))
                    %# overwrite options. If you want you can test for the right class here
                    %# Also, if you find out that there is an option you keep getting wrong,
                    %# you can use "if strcmp(inpName,'problemOption'),testMore,end"-statements
                    options.(inpName) = pair{2};
                else
                    error('%s is not a recognized parameter name',inpName)
                end
            end
            fdnames = fieldnames(options);
            for i = 1:length(fdnames)
                fdname = fdnames{i};
                obj.(fdname) = options.(fdname);
            end
            obj.WaitbarRefresh();
        end
        
        function WaitbarRefresh(obj)
            Bartype = obj.bartype;
            Steps = obj.steps;
            vv = [];
            if strcmpi('Bar',Bartype)
                p = floor(obj.percent*Steps)+1;
                vv = [1,p,Steps+1+p,Steps+2];
            end
            if strcmpi('Pie',Bartype)
                realSteps = obj.RealSteps;
                p = floor(floor(obj.percent*Steps)*(realSteps/Steps))+1;
                vv = [1,2:p+1,1];
            end
            set(obj.Patch,'faces',vv, 'FaceColor', obj.fillcolor,'FaceAlpha',obj.alpha, 'LineStyle','none');
            drawnow;
        end
    end
end