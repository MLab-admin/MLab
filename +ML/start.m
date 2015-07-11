function start(varargin)
%ML.start MLab start
%   ML.start() starts MLab. All dependencies are automatically added to
%   Matlab's path.
%
%   See also ML.stop
%
%   More on <a href="matlab:ML.doc('ML.start');">ML.doc</a>

%! TO DO
%   - Improve help (detail the settings).
%   - ML.doc

% --- Persistent variables ------------------------------------------------

mlock
persistent startup

% -------------------------------------------------------------------------

% --- Inputs
in = ML.Input;
in.plugin({}) = @(x) ischar(x) || iscellstr(x);
in = +in;

% Cellification
if ischar(in.plugin), in.plugin = {in.plugin}; end

% --- Get configuration file
    
% Define configuration file
cname = [prefdir filesep 'MLab.mat'];

% Check existence
if ~exist(cname, 'file')
    ML.Config.default;
end

% Load configuration
config = ML.config;

if isempty(in.plugin)
    
    % --- Preparation
    cws = get(0,'CommandWindowSize');
    
    % --- Character set
    feature('DefaultCharacterSet', config.charset);
    
    % --- Warnings
    warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');
    
    
    % --- Add MLab path
    addpath(config.path, '-end');
    
    % --- Plugins
    if isempty(startup)
        
        % Plugins list
        L = ML.Plugins.list;
        
        % Plugins
        for i = 1:numel(L)
            start_plugin(L{i});
        end
        
    end
    
    % --- Start message
    if isempty(startup)
        ML.CW.line('MLab is started', 'align', 'right', 'marker', ' ');
    else
        ML.CW.line('~bc[limegreen]{MLab is started}', 'align', 'right', 'marker', ' ');
    end
    
    % Welcome message
    if isempty(startup) && config.startup.disp_message
        
        tmp = config.startup.message;
        tmp = regexprep(tmp, '<user:name>', config.user.name);
        ML.CW.line(tmp, 'align', 'right', 'marker', ' ');
        
    end
    
    ML.CW.line;
    
    if isempty(startup)
        
        % --- Check updates
        if config.startup.update
            % TO DO.
            % ML.Updates.check
        end
        
        startup = false;
    end

else
    
    for i = 1:numel(in.plugin)
        start_plugin(in.plugin{i});
    end
    
end

rehash   
    
% -------------------------------------------------------------------------
    function start_plugin(p)
        
        P = ML.Plugins.path(p);
        
        % Add plugin path
        addpath(P.path, '-end');
        
        % Start plugin
        if P.start.exist, P.start.run(); end
        
    end

end