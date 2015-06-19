function out = default(varargin)
%ML.Config.default Set MLab configuration structure to default
%   C = ML.CONFIG.DEFAULT() sets the MLab configuration structure to its
%   default value and returns it.
%
%   C = ML.CONFIG.GET(..., 'cfile', CFILE) uses the tag CFILE to save in
%   the PREFDIR directory. The default value is 'MLab'.
%
%   C = ML.CONFIG.GET(..., 'quiet', false) displays a creation message.
%
%   See also ML.config.
%
%   Reference page in Help browser: <a href="matlab:doc ML.Config.get">doc ML.Config.get</a>
%   <a href="matlab:doc ML">MLab documentation</a>

% === Input variables =====================================================

in = inputParser;
in.addParamValue('cfile', 'MLab', @ischar);
in.addParamValue('quiet', true, @islogical);

in.parse(varargin{:});
in = in.Results;

% -------------------------------------------------------------------------

fname = [prefdir filesep in.cfile '.mat'];

% =========================================================================

% --- Create default configuration structure
config = struct();

config.charset = 'UTF8';

tmp = mfilename('fullpath');
config.path = tmp(1:end-19);

config.startup = struct(...
    'check_updates', true, ...
    'autostart', true);

config.updates = struct(...
    'mirror_url', 'http://www.candelier.fr/MLab/', ...
    'check_delete', true);

config.user = struct(...
    'name', '', ...
    'email', '');

config.plugins = struct();

% --- Save configuration structure
save(fname, 'config');

% --- Message display
if ~in.quiet
    display('The configuration file has been reset to default.');
end

% --- Output
if nargout
    out = config;
end