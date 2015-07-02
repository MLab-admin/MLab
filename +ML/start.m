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

% --- Prepare display
cws = get(0,'CommandWindowSize');

% --- Startup
if isempty(startup)
            
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
