function uninstall(varargin)
% ML.uninstall MLab uninstall
%   ML.uninstall() uninstalls MLab and all associated plugins.
%
%   ML.uninstall('plugins', P) uninstalls only the plugin(s) P. P can be 
%   either a string (single plugin name) or a cell of string (list of 
%   plugin names).
%
%   ML.uninstall(..., 'config', true) also uninstalls the configuration
%   files. After uninstallation with this option set to true, there is no 
%   trace left of MLab in the filesystem.
%
%   See also ML.stop
%
%   More on <a href="matlab:ML.doc('ML.uninstall');">ML.doc</a>

% --- Inputs
in = ML.Input;
in.plugins({}) = @(x) ischar(x) || iscellstring(x);
in.config(false) = @islogical;
in = +in;

% Cellification
if ischar(in.plugins)
    in.plugins = {in.plugins};
end

% --- Load configuration
config = ML.config;

% --- Remove MLab
if isempty(in.plugins)
   
    % Uninstall message
    cws = get(0,'CommandWindowSize');
    ML.CW.print('%s~bc[cornflowerblue]{MLab is uninstalled}\n', repmat(' ', [1 cws(1)-20]));
    ML.CW.line;
   
    % Remove MLab
    warning off
    rmpath(genpath(config.path));
    rmdir(config.path, 's');
    warning on
    
    % Remove configuration file
    if in.config
        delete([prefdir filesep 'MLab.mat']);
    end
    
end
    
% --- Remove plugins

for i = 1:numel(in.plugins)
    
    % Remove plugin
    warning off
    rmdir([config.path 'Plugins' filesep in.plugins{i}], 's');
    warning on
    
    % Remove configuration file
    if in.config
        fname = [prefdir filesep 'MLab_' in.plugins{i} '.mat'];
        if exist(fname, 'file'), delete(fname); end
    end
end

rehash
