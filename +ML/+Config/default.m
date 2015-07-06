function out = default(varargin)
%ML.Config.default Reset default configuration
%   ML.Config.default() resets MLab configuration to default.
%
%   ML.Config.default(..., 'cfile', CFILE) saves the default 
%   configuration in a specific file in the PREFDIR directory. The default 
%   value of CFILE is 'MLab'.
%
%   ML.Config.default(..., 'quiet', false) displays a creation message.
%
%   C = ML.Config.default(...) returns the configuration structure.
%
%   See also ML.config.
%
%   More on <a href="matlab:ML.doc('ML.Config.default');">ML.doc</a>

% === Input variables =====================================================

in = ML.Input;
in.cfile('MLab') = @ischar;
in.quiet(true) = @islogical;
in = +in;

% -------------------------------------------------------------------------

fname = [prefdir filesep in.cfile '.mat'];

% =========================================================================

% --- Create default configuration structure
config = struct();

config.version = 1;

config.charset = 'UTF8';

tmp = mfilename('fullpath');
config.path = tmp(1:end-19);

config.startup = struct('autostart', true, ...
    'update', true, ...
    'disp_message', true, ...
    'message', 'Hello <user:name>');

config.start = struct('update', false);

config.updates = struct('repository', 'https://github.com/MLab-admin/MLab.git');

config.shortcut = struct();
config.shortcut.start = struct('value', false, ...
    'desc', 'Start', ...
    'code', ['tmp = load([prefdir filesep ''MLab.mat'']);' char(10) ...
        'addpath(tmp.config.path, ''-end'');' char(10) ...
        'ML.start;'], ...
    'icon', 'Images/Shortcuts/Start.png');
config.shortcut.stop = struct('value', false, ...
    'desc', 'Stop', ...
    'code', failsafe('ML.stop;'), ...
    'icon', 'Images/Shortcuts/Stop.png');
config.shortcut.config = struct('value', false, ...
    'desc', 'Config', ...
    'code', failsafe('ML.config;'), ...
    'icon', 'Images/Shortcuts/Config.png');
config.shortcut.update = struct('value', false, ...
    'desc', 'Update', ...
    'code', failsafe('ML.update;'), ...
    'icon', 'Images/Shortcuts/Update.png');

config.user = struct('name', '', 'email', '');

% --- Save configuration structure
save(fname, 'config');

% --- Message display
if ~in.quiet
    printf('The configuration file ''%s'' has been reset to default.', in.cfile);
end

% --- Output
if nargout
    out = config;
end

end

% =========================================================================
function out = failsafe(code)
    
    nl = char(10);

    out = ['try' nl ...
        '    ' code nl ...
        'catch' nl '    '];
    
    if usejava('desktop')
        out = [out 'fprintf(''MLab is not started.\n <a href="matlab:tmp = load([prefdir filesep ''''MLab.mat'''']);' ...
            'addpath(tmp.config.path, ''''-end''''); ML.start;">Click here</a> to start MLab.\n'');'];
    else
        out = [out 'fprintf(''MLab is not started.\n You have to run the \033[1;33;40mML.start\033[0m script to start MLab.\n'');'];
    end
    
    out = [out nl 'end'];
    
end