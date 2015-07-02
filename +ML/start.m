function start()
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

% --- Get configuration file

% Define configuration file
cname = [prefdir filesep 'MLab.mat'];

% Check existence
if ~exist(cname, 'file')
    ML.Config.default;
end

% Load configuration
config = ML.config;

% --- Rehash
addpath(genpath(config.path), '-end');
rehash

% --- Prepare display
cws = get(0,'CommandWindowSize');

% --- Startup
if isempty(startup)
    
    % --- Welcome message
    tmp = 'Hello';
    if ~isempty(config.user.name)
        tmp = [tmp ', ' config.user.name];
    end
    ML.CW.print('%s%s\n', repmat(' ', [1 cws(1)-numel(tmp)-1]), tmp);
            
    % --- Plugins startups
    L = ML.Plugins.list;
    for i = 1:numel(L)
        try 
            ML.(L{i}).startup; 
        catch
        end
    end
    
end

% --- Character set
feature('DefaultCharacterSet', config.charset);

% --- Warnings
warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

% --- Start message
ML.CW.print('%s~bc[limegreen]{MLab is started}\n', repmat(' ', [1 cws(1)-16]));
ML.CW.line;

if isempty(startup)    
    
    % --- Check updates
    if config.startup.check_updates
        ML.Updates.check
    end
    
    startup = false;
end
