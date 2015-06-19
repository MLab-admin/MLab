function start()
%ML.start MLab starting point
%   ML.START() starts MLab.
%
%   This function can be executed automatically at Matlab startup. To set 
%   this up you need to create a startup.m file at the following location:
%
%   $matlabroot/toolbox/local/startup.m
%
%   The startup.m should contain the following commands:
%
%   if exist([prefdir filesep 'MLab.mat'], 'file')
%    	tmp = load([prefdir filesep 'MLab.mat']);
%       addpath(genpath(tmp.config.path), '-end');
%       if tmp.config.startup.autostart
%           ML.start
%       end
%   end
%   
%   See also ML.Config.config.
%
%   Reference page in Help browser: <a href="matlab:doc ML.start">doc ML.start</a>
%   <a href="matlab:doc ML">MLab documentation</a>

% === Persistent variables ================================================

mlock
persistent startup

% =========================================================================

% --- Cleaning
close all
clear global
evalin('base', 'clear');

% --- Startup
if isempty(startup)
    
    % --- Configuration file
    config = ML.Config.get('quiet', false);
            
    % --- Check updates
    if config.startup.check_updates
        ML.Updates.check
    end
    
    % --- Misc startups
    if opengl('info')
        set(0, 'DefaultFigureRenderer', 'painters');
    end
    
    % --- Plugins startups
    L = ML.Plugins.list;
    for i = 1:numel(L)
        try 
            ML.(L{i}).startup; 
        catch
        end
    end

else
    
    clc
    
    % --- Configuration file
    config = ML.Config.get('quiet', true);
    
end

startup = false;

% --- Rehash
addpath(genpath(config.path), '-end');
rehash

% --- Character set
feature('DefaultCharacterSet', config.charset);

% --- Warnings
warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

% --- Welcome message
fprintf('<strong>Hello %s</strong>\n', config.user.name);
ML.CW.line;


