function stop()
%ML.stop MLab stop
%   ML.stop() stops MLab. All dependencies are automatically removed from 
%   Matlab's path.
%
%   See also ML.start
%
%   More on <a href="matlab:ML.doc('ML.stop');">ML.doc</a>

%! TO DO:
%   - ML.doc

% --- Load configuration
config = ML.config;

% --- Stop message
cws = get(0,'CommandWindowSize');
ML.CW.print('%s~bc[red]{MLab is stopped}\n', repmat(' ', [1 cws(1)-16]));
ML.CW.line;

% --- Remove MLab from path

% MLab
rmpath(config.path);

% Plugins


rehash