function WaitbarTest()

p = figure();
Steps = 100;
hb = WaitBarCreate('parent',p,'Position',[0.1,0.2,0.8,0.1],'BarType','Bar','FillColor','r', 'Alpha',0.5, 'Steps',Steps,'BorderStyle','-','Percent',0.5,'BorderColor','b');
hp = WaitBarCreate('Position',[0.3,0.4,0.4,0.4],'BarType','Pie','FillColor','b', 'Alpha',0.5, 'Steps',Steps,'BorderStyle','-','Percent',0.5,'BorderColor','r');
pause(2);
for i = 0:100
    WaitBarUpdate(hb, 'Percent',i/100);
    WaitBarUpdate(hp, 'Percent',i/100);
    pause(0.01);
end
end