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

config.charset = 'UTF8';

tmp = mfilename('fullpath');
config.path = tmp(1:end-19);

config.startup = struct('autostart', true, ...
    'update', true, ...
    'disp_message', true, ...
    'message', 'Hello <user:name>');

config.updates = struct('repository', 'https://github.com/MLab-admin/MLab.git');

config.user = struct(...
    'name', '', ...
    'email', '');

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