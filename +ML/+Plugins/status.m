function out = status(pname)
%ML.Plugins.status Tell if a plugin is installed
%   B = ML.PLUGINS.STATUS(PNAME) returns a boolean B telling if the plugin
%   PNAME is installed. PNAME can be a string or a cell of strings. If
%   PNAME is a celle of strings, B is an array of the same size.
%
%   See also ML.plugins.

% === Input variables =====================================================

in = inputParser;
in.addRequired('pname', @(x) ischar(x) || iscellstr(x));

in.parse(pname);
in = in.Results;

% =========================================================================

% --- Get Plugins list
L = ML.Plugins.list('local');

out = ismember(in.pname, L);